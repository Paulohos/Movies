import AppConfiguration
import NetworkLayer
import PopularMovies

var Current: World = .release

struct World {
    public let environmentConfigurationService: EnvironmentConfigurationService
    public let networkService: NetworkService
    public let popularMoviesService: PopularMoviesService
}

extension World {
    static var release: Self {

        let environmentConfigurationService = EnvironmentConfigurationService.live

        let networkService = NetworkService.live(
            appConfiguration: environmentConfigurationService
        )

        let popularMoviesService = PopularMoviesService.live(networkService)

        let world = World(
            environmentConfigurationService: environmentConfigurationService,
            networkService: networkService,
            popularMoviesService: popularMoviesService
        )

        NetworkLayer.Current = world
        PopularMovies.Current = world

        return world
    }
}

extension World: NetworkLayer.World {}
extension World: PopularMovies.World {}
