import AppConfiguration
import Foundation
import SharedModels
import Utilities

extension ListOfMoviesView {

    enum ViewState: Equatable {
        case showData
        case error(DefaultError)
        case isLoading
        case isPrefetching
    }

    enum ScreenRoute: Equatable {
        case detail(movie: PopularMoviesList)
    }

    final class ViewModel: ObservableObject {

        private let popularMoviesService: PopularMoviesService

        @Published
        var state: ViewState = .isLoading
        @Published
        var response = PopularMoviesResponse()
        @Published
        var route: ScreenRoute?

        let bannerUrl: String
        var loadMoreOffset: Int = -15

        private var currentPage = 1

        private var hasMore: Bool {
            currentPage < response.totalPages
        }

        init(popularMoviesService: PopularMoviesService, 
             environmentConfigurationService: EnvironmentConfigurationService
        ) {
            self.popularMoviesService = popularMoviesService
            self.bannerUrl = environmentConfigurationService.bannerUrl() + .bannerPath
        }

        func onAppear() async {
            await fetchMovies()
        }

        func didTap(_ movie: PopularMoviesList) {
            route = .detail(movie: movie)
        }

        func posterURL(_ movieIndex: Int) -> URL? {
            .init(string: bannerUrl + response.results[movieIndex].posterPath)
        }

        func tryAgain() async {
            await self.fetchMovies()
        }

        //MARK: - Request
        @MainActor
        private func fetchMovies(_ loading: ViewState = .isLoading) async {
            self.state = loading
            do {
                let response = try await popularMoviesService.fetchListOfPopularMovies(currentPage)
                
                if loading == .isPrefetching {
                    self.response.totalPages = response.totalPages
                    self.response.results.append(contentsOf: response.results)
                } else {
                    self.response = response
                }
                self.state = .showData
            } catch {
                self.state = .error(.defaultError)
            }
        }

        //MARK: - PAGINATION
        func loadMoreContent(currentItem item: PopularMoviesList) async {
            let thresholdIndex = response.results.index(response.results.endIndex, offsetBy: loadMoreOffset)

            guard
                state != .isPrefetching,
                hasMore,
                thresholdIndex > .zero,
                response.results[safeIndex: thresholdIndex]?.id == item.id
            else { return }
            currentPage += 1
            await fetchMovies(.isPrefetching)
        }
    }
}

private extension String {
    static let bannerPath: Self = "/w500"
}
