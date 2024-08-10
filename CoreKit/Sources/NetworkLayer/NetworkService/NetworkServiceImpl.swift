import AppConfiguration
import Foundation

extension NetworkService {
    /// "Live" constructor for NetworkService
    ///
    /// The service was devised to be super-minimal. Note that the *only* part that cannot be tested is the `baseNetworkRequest`
    /// function, upon which all the outer layers of the `public` interface are built upon. The `baseNetworkRequest` function's
    /// impl is the same signature as the `async` `URLSession` method.
    ///
    /// - Parameters:
    ///   - appConfiguration: AppConfiguration dependency
    ///   - notifiersService: NotifiersService dependency
    /// - Returns: A live `NetworkService`
    public static func live(
        appConfiguration: EnvironmentConfigurationService
    ) -> NetworkService {
        .init(
            appConfiguration: appConfiguration,
            baseNetworkRequest: {
                return try await URLSession.shared.data(for: $0)
            }
        )
    }

    /// This is for testing the live network service; it gives us an opportunity to capture the `URLRequest` that's sent so we can test on it
    static func testMock(
        appConfiguration: EnvironmentConfigurationService,
        mockValueProvider: @escaping (URLRequest) -> NetworkResponse
    ) -> NetworkService {
        .init(
            appConfiguration: appConfiguration,
            baseNetworkRequest: { request in
                switch mockValueProvider(request) {
                case .success(let value): return value
                case .failure(let error): throw error
                }
            }
        )
    }
}
