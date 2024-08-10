import NetworkLayer

public struct PopularMoviesService {
    let fetchListOfPopularMovies: (
        _ page: Int
    ) async throws -> PopularMoviesResponse
}

extension PopularMoviesService {
    public static func live(_ networkService: NetworkService) -> Self {
        .init(
            fetchListOfPopularMovies: { page in
                try await networkService.call(endpoint: .popularMovies(page: page))
            }
        )
    }

    public static func mock(popularMovies: PopularMoviesResponse? = nil) -> Self{
        .init(
            fetchListOfPopularMovies: { _ in popularMovies! }
        )
    }
}
