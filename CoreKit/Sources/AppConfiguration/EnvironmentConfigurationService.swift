import Foundation

public struct EnvironmentConfigurationService {
    public let baseUrl: () -> String
    public let bundleID: () -> String
    public let apiKey: () -> String
    public let accessToken: () -> String?
    public let bannerUrl: () -> String
}

 extension EnvironmentConfigurationService {
     public static let live: Self = {
        .init(
            baseUrl: {
                get("baseURL") ?? ""
            },
            bundleID: {
                get("bundleId") ?? ""
            },
            apiKey: {
                get("apiKey") ?? ""
            },
            accessToken: {
                get("accessToken")
            },
            bannerUrl: {
                get("bannerUrl") ?? ""
            }
        )
    }()

     public static func mock(
        baseUrl: String? = nil,
        bundleID: String? = nil,
        apiKey: String? = nil,
        accessToken: String? = nil,
        bannerUrl: String? = nil
     ) -> Self {
         .init(
            baseUrl: { baseUrl! },
            bundleID: { bundleID! },
            apiKey: { apiKey! },
            accessToken: { accessToken },
            bannerUrl: { bannerUrl! }
         )
     }
 }

private func get<T>(_ name: String) -> T? {
    guard let enviromentSetting = Bundle.main.infoDictionary?["EnviromentSetting"] as? [String: Any] else { return nil }
    guard let key = enviromentSetting[name] else { return nil }

    return key as? T
 }
