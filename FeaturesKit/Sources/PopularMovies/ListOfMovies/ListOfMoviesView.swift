import AppConfiguration
import DesignerSystem
import Router
import Scheme
import SwiftUI
import UIUtilities

public struct ListOfMoviesView: View {
    typealias Strings = L10n.Localizable
    let router: AnyRouter
    @StateObject var viewModel: ViewModel
    private let columns = Array(repeating: GridItem(.flexible()), count: .columns)

    public var body: some View {
        GeometryReader{ proxy in
            ZStack {
                Color.black
                    .ignoresSafeArea()
                switch viewModel.state {
                case .error(let error):
                    GenericErrorView.genericView(error: error) {
                        Task { await viewModel.tryAgain() }
                    }
                case .isLoading:
                    LoadingView()
                default:
                    VStack {
                        Text(Strings.popular.uppercased())
                            .foregroundStyle(.white)
                        ScrollView {
                            LazyVGrid(columns: columns) {
                                ForEach(viewModel.response.results.indices, id: \.self) { index in
                                    MoviesCellView(
                                        urlImage: viewModel.posterURL(index),
                                        action: {
                                            viewModel.didTap(viewModel.response.results[index])
                                        })
                                    .frame(
                                        width: proxy.size.width / .columnsCount - .cellSpace,
                                        height: .cellHeight
                                    )
                                    .onAppear {
                                        Task {
                                            let movie = viewModel.response.results[index]
                                            await viewModel.loadMoreContent(currentItem: movie)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .task {
                await viewModel.onAppear()
            }
            .onChange(of: viewModel.route) { newValue in
                switch newValue {
                case .detail(let movie):
                    router.showScreen(.sheet) {
                        RoutingView(router.presentingSheet) { router in
                            MovieDetailsView.makeMovieDetailsView(movie: movie)
                        }
                    }
                case .none:
                    break
                }
                viewModel.route = nil
            }
        }
    }
}

#Preview {
    RoutingView { router in
        ListOfMoviesView(
            router: router,
            viewModel: .init(
                popularMoviesService: PopularMoviesService.mock(
                    popularMovies: .init(
                        results:  [
                            .init(
                                id: 111,
                                adult: false,
                                backdropPath: "/9l1eZiJHmhr5jIlthMdJN5WYoff.jpg",
                                originalIitle: "Deadpool & Wolverine",
                                voteAverage: 7.9050000000000002,
                                popularity: 14413.653,
                                posterPath: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
                                overview: "A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.",
                                title: "Deadpool & Wolverine",
                                originalLanguage: "en",
                                voteCount: 1499,
                                releaseDate: "2024-07-24",
                                video: false
                            ),
                            .init(
                                id: 2222,
                                adult: false,
                                backdropPath: "/3q01ACG0MWm0DekhvkPFCXyPZSu.jpg",
                                originalIitle: "Bad Boys: Ride or Die",
                                voteAverage: 7.6580000000000004,
                                popularity: 4076.1889999999999,
                                posterPath: "/oGythE98MYleE6mZlGs5oBGkux1.jpg",
                                overview: "After their late former Captain is framed, Lowrey and Burnett try to clear his name, only to end up on the run themselves.",
                                title: "Bad Boys: Ride or Die",
                                originalLanguage: "en",
                                voteCount: 1377,
                                releaseDate: "2024-06-05",
                                video: false
                            ),
                            .init(
                                id: 333,
                                adult: false,
                                backdropPath: "/2RVcJbWFmICRDsVxRI8F5xRmRsK.jpg",
                                originalIitle: "A Quiet Place: Day One",
                                voteAverage: 6.9880000000000004,
                                popularity: 3508.0729999999999,
                                posterPath: "/yrpPYKijwdMHyTGIOd1iK1h0Xno.jpg",
                                overview: "As New York City is invaded by alien creatures who hunt by sound, a woman named Sam fights to survive with her cat.",
                                title: "A Quiet Place: Day One",
                                originalLanguage: "en",
                                voteCount: 1096,
                                releaseDate: "2024-06-26",
                                video: false
                            )
                        ],
                        totalPages: 1
                    )
                ), environmentConfigurationService: EnvironmentConfigurationService.mock(bannerUrl: "https://image.tmdb.org/t/p")
            )
        )
    }
}

// MARK: - Factory
public extension ListOfMoviesView {
    static func makeListOfMoviesView(router: AnyRouter) -> some View {
        ListOfMoviesView(
            router: router,
            viewModel: .init(
                popularMoviesService: Current.popularMoviesService, environmentConfigurationService: Current.environmentConfigurationService
            )
        )
    }
}

private extension CGFloat {
    static let cellHeight: Self = 190
    static let columnsCount: Self = 3
    static let cellSpace: Self = 6
}

private extension Int {
    static let columns: Self = 3
}

