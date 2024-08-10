import AppConfiguration

public protocol World {
    var environmentConfigurationService: EnvironmentConfigurationService { get }
}

// swiftlint:disable implicitly_unwrapped_optional
public var Current: World!
