import AppConfiguration
import Foundation
import Utilities

extension MovieDetailsView {

    final class ViewModel: ObservableObject {

        let movie: PopularMoviesList
        let bannerUrl: String

        var footer: String {
            var array = [movie.originalLanguage.uppercased()]
            if let year = movie.releaseDate.toDate(dateFormat: .isoDate)?.yearIn {
                array.append(String(year))
            }

            if let rate = movie.voteAverage.rounded() {
                array.append("\(String.tomate) \(rate)")
            }

            return array.joined(separator: "\(String.dotSeparator)")
        }

        init(movie: PopularMoviesList, environmentConfigurationService: EnvironmentConfigurationService) {
            self.movie = movie
            self.bannerUrl = environmentConfigurationService.bannerUrl() + .bannerPath
        }

        func backdropURL() -> URL? {
            guard let backdropPath = movie.backdropPath else { return nil}

            return .init(string: bannerUrl + backdropPath)
        }
    }
}

private extension String {
    static let tomate: Self = "🍅"
    static let dotSeparator: Self = " • "
    static let bannerPath: Self = "/original"
}
