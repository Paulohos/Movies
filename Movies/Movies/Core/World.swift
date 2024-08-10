import AppConfiguration
import NetworkLayer

var Current: World = .release

struct World {
    public let environmentConfigurationService: EnvironmentConfigurationService
    public let networkService: NetworkService
}

extension World {
    static var release: Self {

        let environmentConfigurationService = EnvironmentConfigurationService.live

        let networkService = NetworkService.live(
            appConfiguration: environmentConfigurationService
        )

        let world = World(
            environmentConfigurationService: environmentConfigurationService,
            networkService: networkService
        )

        NetworkLayer.Current = world

        return world
    }
}

extension World: NetworkLayer.World {}
