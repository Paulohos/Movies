import Foundation
import UIKit

private enum Headers: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case accept = "Accept"
}

private enum HeaderValues: String {
    case json = "application/json"
    case bearer = "Bearer"
}

extension NetworkService {

    private func getBaseURL(for endpoint: Endpoint) throws -> URL {
        var baseURL: URL
        // decide which endpoint to use
        switch endpoint.descriptor.origin {
        case .localizedAPI:
            guard
                let unwrappedURL = URL(string: appConfiguration.baseUrl())
            else {
                throw NetworkServiceError.noEndpointInStorage
            }

            baseURL = unwrappedURL.appendingPathComponent(endpoint.descriptor.version.rawValue)

        case .custom(let customBaseURL):
            guard let url = URL(string: customBaseURL) else {
                throw NetworkServiceError.invalidCustomURL
            }

            baseURL = url
        }

        // construct full URL
        baseURL = baseURL.appendingPathComponent(endpoint.path)

        // add query items if necessary
        guard endpoint.descriptor.method == .get, !endpoint.queryItems.isEmpty else {
            return baseURL
        }

        let queryItems: [URLQueryItem] = endpoint.queryItems.map(makeQueryItem(_:))

        guard let urlWithQueryItems = baseURL.addQueryItems(queryItems) else {
            print("🌐 Failed to attach query items")
            throw NetworkServiceError.queryItemAttachmentFailed(baseURL.debugDescription)
        }

        return urlWithQueryItems
    }

    private func getHeaders(for endpoint: Endpoint, additionalSettings: [AdditionalSettings], shouldReturnDefaultError: Bool) throws -> [String: String] {
        var headers: [String: String] = [
            Headers.contentType.rawValue: HeaderValues.json.rawValue,
            Headers.accept.rawValue: HeaderValues.json.rawValue,
        ]

        if endpoint.requiresAccessToken {
            let authToken: String = appConfiguration.accessToken() ?? ""
            headers[Headers.authorization.rawValue] = "\(HeaderValues.bearer.rawValue) \(authToken)"
        }

        if !additionalSettings.isEmpty {
            additionalSettings.forEach {
                switch $0 {
                case .appendHeader(let headerArray):
                    headerArray.forEach {
                        for (key, value) in $0 {
                            headers[key] = value
                        }
                    }

                case .overrideHeader(let headerArray):
                    headers = [:]
                    headerArray.forEach {
                        for (key, value) in $0 {
                            headers[key] = value
                        }
                    }

                default:
                    break
                }
            }
        }

        return headers
    }

    private func getCustomTimeoutInterval(_ additionalSettings: [AdditionalSettings]) -> Double? {
        if !additionalSettings.isEmpty {
            for setting in additionalSettings {
                if case .setTimeOut(let int) = setting {
                    return int
                }
            }
        }

        return nil
    }

    /// This is the super-internal request method: it handles the construction of a `URLRequest`, throwing errors if `httpStatus > 500`,
    /// and passes through the returned `(httpStatus, data)` if everything went fine
    private func request(for endpoint: Endpoint, body: Data?, additionalSettings: [AdditionalSettings], shouldReturnDefaultError: Bool) async throws -> (Int, Data) {
        // construct request
        let baseURL = try getBaseURL(for: endpoint)
        let headers = try getHeaders(for: endpoint, additionalSettings: additionalSettings, shouldReturnDefaultError: shouldReturnDefaultError)

        var request = URLRequest(url: baseURL)
        request.httpMethod = endpoint.descriptor.method.rawValue
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

        if let timeout = getCustomTimeoutInterval(additionalSettings) {
            request.timeoutInterval = timeout
        }

        print("\(endpoint) 🌐 Sending API `\(endpoint.descriptor.method)` request to URL: \(baseURL)")

        // set body
        if let body {
            request.httpBody = body
        }
        /// Printinh header and body description
        self.printDescription(type: .headerAndBody(request))

        // do request
        let (data, response) = try await baseNetworkRequest(request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw handleErrorReturns(
                shouldReturnDefaultError,
                errorReturn: NetworkServiceError.invalidHTTPResponse
            )
        }

        // Print data request on log
        self.printDescription(type: .response(request, data, httpResponse))

        guard httpResponse.statusCode < 500 else {
            // 500 level errors are server errors, not API errors, so we pass them through as explicit errors
            throw handleErrorReturns(
                shouldReturnDefaultError,
                errorReturn: NetworkServiceError.serverError(httpResponse.statusCode),
                statusCode: httpResponse.statusCode
            )

        }
        return (httpResponse.statusCode, data)
    }

    func unhandledStatusError(_ status: Int, data: Data) -> Error {
        switch status {
        case 401: return NetworkServiceError.authenticationFailure
        case let status: return NetworkServiceError.unhandledHTTPStatus(status, data)
        }
    }

    func handleErrorReturns(_ shouldReturnDefaultError: Bool, errorReturn: Error, statusCode: Int = .zero) -> Error {
        guard shouldReturnDefaultError else {
            return errorReturn
        }
        /// This implementation limits the reusability of the framework across different projects.
        /// To enable reuse, adjustments in this section are necessary.
        /// Specifically, we must ensure the generation of the appropriate error object or directly return the `data` or the`status code`.
        /// This project adheres to a standard error structure for errors falling within the range of 400 to 499,
        /// Embodied by the DefaultError struct.
        /// An example of such an error might be {code: 123, title: "Oops... something went wrong", message: "Email or password invalid"}..
        /// This structure includes a code, a title, and a message, which are intended for display on the screen.
        /// This section addresses invalid HTTP responses, encompassing errors ranging from 500 and above,  parse error json , including unknown errors.
        /// To address these, we establish a default message to handle them effectively.
        return NetworkServiceError.defaultError(.defaultError(statusCode: statusCode))
    }

    /// This is the version of `request` that does a 401 retry (if the boolean is set)
    func request(for endpoint: Endpoint, body: Data?, retryOn401: Bool, additionalSettings: [AdditionalSettings], shouldReturnDefaultError: Bool) async throws -> (Int, Data) {
        let response = try await request(for: endpoint, body: body, additionalSettings: additionalSettings, shouldReturnDefaultError: shouldReturnDefaultError)

        guard response.0 == 401, retryOn401 else {
            return response
        }

        print("\(endpoint) 🌐 Attempting automatic 401 retry 🛟")
        do {
            try await withCheckedThrowingContinuation { self.retryOn401($0.resume(with:)) }
            print("\(endpoint) 🌐 Automatic 401 retry success ✅")
        } catch {
            print("\(endpoint) 🌐 Automatic 401 retry failure ❌")
            throw NetworkServiceError.retryOn401(error)
        }

        // This is the retry request after the refrash token request
//        do {
//            return try await request(for: endpoint, body: body, additionalSettings: additionalSettings, shouldReturnDefaultError: shouldReturnDefaultError)
//        } catch {
//            // Making user logout automaticcaly becouse the refresh token didn't work
//            nitifierService.userNeedsLogout.send()
//            throw error
//        }
        return try await request(for: endpoint, body: body, additionalSettings: additionalSettings, shouldReturnDefaultError: shouldReturnDefaultError)
    }
}

/// These extensions are helpers for our `async` function that handles the API calls
extension NetworkService {
    private func makeQueryItem(_ item: APIQueryItem) -> URLQueryItem {
        switch item {
        case let .keyValue(key, value):
            return .init(name: key, value: value)
            
        case .date(let date):
            return .init(name: "date", value: date.convertToUTC())
        }
    }
}
