import Foundation
import SharedModels

extension NetworkService {

    /// The main back-end interface for `async` `NetworkService` calls. This specific function is marked  `private`, but it handles all the relevant logic.
    /// The actual `public` calls below just wrap this in an logging block, and allows `AsyncCallBuilder` to generate the list of `failures`.
    ///
    /// - Parameters:
    ///   - endpoint: Which endpoint to call
    ///   - body: Body object
    ///   - success: The success status matcher
    ///   - shouldRetundDefaultError: If `true` it won't return the error retrieved from server, but  a `DefaultError` object
    ///   - retryOn401: If true, we will retry on 401 as long as `success` and `failures`
    /// - Returns: The decoded valid API response.
    private func callAsync(
        endpoint: Endpoint,
        body: Data?,
        additionalSettings: [AdditionalSettings],
        shouldReturnDefaultError: Bool
    ) async throws -> Data {
        let actuallyRetryOn401 =
            endpoint.requiresAccessToken

        let (status, data) = try await request(for: endpoint, body: body, retryOn401: actuallyRetryOn401, additionalSettings: additionalSettings, shouldReturnDefaultError: shouldReturnDefaultError)

        switch status {
        case 200...299:
            return data
        default:
            var errorHandle: Error
            do {
                /// This implementation limits the reusability of the framework across different projects.
                /// To enable reuse, adjustments in this section are necessary.
                /// Specifically, we must ensure the generation of the appropriate error object or directly return the `data`.
                /// This project adheres to a standard error structure for errors falling within the range of 400 to 499,
                /// such as {code: 123, title: "Oops... something went wrong", message: "Email or password invalid"}.
                var defaultError = try JSONDecoder().decode(DefaultError.self, from: data)
                defaultError.code = status
                errorHandle = NetworkServiceError.defaultError(defaultError)
            } catch {
                errorHandle = handleErrorReturns(
                    shouldReturnDefaultError,
                    errorReturn: unhandledStatusError(status, data: data),
                    statusCode: status
                )
            }
            throw errorHandle
        }
    }

    private func wrapInErrorLogger<R>(for endpoint: Endpoint, function: () async throws -> R) async throws -> R {
        do {
            let value = try await function()
            print("\(endpoint) 🌐 Call succeeded! ✅")
            return value
        } catch {
            print("\(endpoint) 🌐 Call failed with error: \(error) ❌")
            if let code = error.errorCode, code == -999 {
                /// -999 means the resquest was cancelled
                throw NetworkServiceError.cancelledRequest
            }
            throw error
        }
    }
}

// MARK: Actual Public Methods, Generated Code
extension NetworkService {
    public func call<Return: Decodable>(
        endpoint: Endpoint,
        body: (any Encodable)? = nil,
        additionalSettings: [AdditionalSettings] = [],
        shouldReturnDefaultError: Bool = true
    ) async throws -> Return {
        try await wrapInErrorLogger(for: endpoint) {
            let data = try await callAsync(
                endpoint: endpoint,
                body: body?.asData,
                additionalSettings: additionalSettings,
                shouldReturnDefaultError: shouldReturnDefaultError
            )

            do {
                return try JSONDecoder().decode(Return.self, from: data)
            } catch {
                self.printDescription(type: .erroParse(error))
                throw handleErrorReturns(
                    shouldReturnDefaultError,
                    errorReturn: NetworkServiceError.jsonParsingFailure
                )
            }
        }
    }

    public func call(
        endpoint: Endpoint,
        body: (any Encodable)? = nil,
        additionalSettings: [AdditionalSettings] = [],
        shouldReturnDefaultError: Bool = true
    ) async throws {
        try await wrapInErrorLogger(for: endpoint) {
            _ = try await callAsync(
                endpoint: endpoint,
                body: body?.asData,
                additionalSettings: additionalSettings,
                shouldReturnDefaultError: shouldReturnDefaultError
            )
        }
    }
}
