import Foundation
import SharedModels

public enum NetworkServiceError: Error {
    case noEndpointInStorage
    case noAuthTokenInStorage
    case queryItemAttachmentFailed(String)
    case serverError(Int)
    case authenticationFailure
    case unhandledHTTPStatus(Int, Data)
    case invalidHTTPResponse
    case retryOn401(Error)
    case defaultError(DefaultError)
    case invalidCustomURL
    case jsonParsingFailure
    case cancelledRequest
    case failToRefreshToken
}

extension NetworkServiceError: CustomDebugStringConvertible {
    public var debugDescription: String {
        var debugMessage: String

        switch self {
        case .noEndpointInStorage:
            debugMessage = "Failed to load patient app API base url from localStorage"

        case .noAuthTokenInStorage:
            debugMessage = "Failed to load required (auth || refresh) token from localStorage"

        case .queryItemAttachmentFailed(let urlString):
            debugMessage = "Failed to attach query items to URL `\(urlString)`"

        case .serverError(let status):
            debugMessage = "Server threw an error, status `\(status)`"

        case .authenticationFailure:
            debugMessage = "Authentication failed"

        case .unhandledHTTPStatus(let status, _):
            debugMessage = "No explicit handler for httpStatus `\(status)`"
            if status > 400 { debugMessage += " (400-level errors can't be matched by APIResponse(.anything))" }

        case .invalidHTTPResponse:
            debugMessage = "Couldn't cast API response as HTTPResponse"

        case .retryOn401(let error):
            debugMessage = "Error retrying during 401: \(error)"

        case .defaultError(let error):
            debugMessage = "Default error: \(error)"

        case .invalidCustomURL:
            debugMessage = "Couldn't parse the custom URL"

        case .jsonParsingFailure:
            debugMessage = "Failure to parsing JSON"

        case .cancelledRequest:
            debugMessage = "The request was cancelled"

        case .failToRefreshToken:
            debugMessage = "Fail to refresh token"
        }

        return debugMessage
    }
}
