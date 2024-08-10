import AppConfiguration
import DesignerSystem
import Scheme
import SDWebImageSwiftUI
import SwiftUI
import UIUtilities

struct MovieDetailsView: View {
    typealias Strings = L10n.Localizable.Movie.Detail
    @StateObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            backGroundView()
            VStack {
                Spacer()
                VStack {
                    description()
                    buttons()
                    HStack {
                        Text("\(viewModel.footer)")
                            .foregroundStyle(Color.secondaryApp)
                            .font(.boldApp(size: .body2))
                        Spacer()
                    }
                    .padding(.top, .paddingSmall)
                }
                .padding(EdgeInsets(top: .paddingExtraLarge, leading: .paddingMedium, bottom: .paddingSmall, trailing: .paddingMedium))
                .background(
                    BlurView()
                )
            }
        }
    }

    @ViewBuilder
    private func description() -> some View {
        Text(viewModel.movie.title)
            .foregroundStyle(Color.secondaryApp)
            .font(.boldApp(size: .h5))
            .padding(.bottom, .paddingMedium)

        Text(viewModel.movie.overview)
            .foregroundStyle(Color.secondaryApp)
            .font(.boldApp(size: .body2))
            .lineSpacing(5)
    }

    @ViewBuilder
    private func buttons() -> some View {
        HStack(alignment: .center) {
            MovieButton(action: {}, with: .imageAndText(image: Image.playFill, text: Strings.watch))
            MovieButton(type: .outline, action: {}, title: Strings.trailer)
                .frame(width: 130)
        }
        .padding(.top, .paddingMedium)
    }

    @ViewBuilder
    private func backGroundView() -> some View {
        GeometryReader{ proxy in
            WebImage(url: viewModel.backdropURL()) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width)
            } placeholder: {
                Rectangle().foregroundColor(.gray.opacity(0.1))
            }
            .indicator(content: { isAnimating, progress in
                VStack {
                    LoadingView()
                        .padding(.top, -.paddingBig)
                }
            })
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .ignoresSafeArea()
        }
    }
}

#Preview {
    MovieDetailsView(
        viewModel: .init(
            movie: .init(
                id: 1111,
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
            ), environmentConfigurationService: EnvironmentConfigurationService.mock(bannerUrl: "https://image.tmdb.org/t/p")
        )
    )
}

// MARK: - Factory
extension MovieDetailsView {
    static func makeMovieDetailsView(movie: PopularMoviesList) -> some View {
        MovieDetailsView(
            viewModel: .init(
                movie: movie,
                environmentConfigurationService: Current.environmentConfigurationService
            )
        )
    }
}
