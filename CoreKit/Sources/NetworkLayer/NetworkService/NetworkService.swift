import AppConfiguration
import Foundation

public class NetworkService {

    /// Lets us access properties that we need to send to the server with every request
    let appConfiguration: EnvironmentConfigurationService
    /// Used to retrieve the `.endpoint` for API requests that need it
    /// Used for automatic 401 token refreshed; re-set by `LoginService` when it is constructed (hence why `class NetworkService`, because we
    /// need the value to propagate to all NetworkService objects underneath the Services.
    var retryOn401: (@escaping (Result<Void, Error>) -> Void) -> Void = { completion in
        completion(.failure(NetworkServiceError.authenticationFailure))
    }

    private(set) var setRetryOn401: Bool = false

    /// This function is the "most minimal async network function"; it's the only piece that needs to depend
    /// on `URLSession`. All other functionality is built on top of this base. This is the only piece that is *not testable*.
    let baseNetworkRequest: (URLRequest) async throws -> (Data, URLResponse)

    init(
        appConfiguration: EnvironmentConfigurationService,
        baseNetworkRequest: @escaping (URLRequest) async throws -> (Data, URLResponse)
    ) {
        self.appConfiguration = appConfiguration
        self.baseNetworkRequest = baseNetworkRequest
    }

    public func setRetryOn401(_ retryClosure: @escaping (@escaping (Result<Void, Error>) -> Void) -> Void) {
        // precondition(!setRetryOn401)

        print("🌐 Automatic API call 401 retry closure set ✅")
        setRetryOn401 = true
        retryOn401 = retryClosure
    }
}
