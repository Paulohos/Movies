import Foundation

public struct PopularMoviesResponse: Decodable {
    var results: [PopularMoviesList]
    var totalPages: Int

    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
    }

    init() {
        results = []
        totalPages = 0
    }

    init(results: [PopularMoviesList], totalPages: Int) {
        self.results = results
        self.totalPages = totalPages
    }
}

struct PopularMoviesList: Decodable, Hashable {
    var id: Int
    var adult: Bool
    var backdropPath: String?
    var originalIitle: String
    var voteAverage: Double
    var popularity: Double
    var posterPath: String
    var overview: String
    var title: String
    var originalLanguage: String
    var voteCount: Int
    var releaseDate: String
    var video: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case backdropPath = "backdrop_path"
        case originalIitle = "original_title"
        case voteAverage = "vote_average"
        case popularity
        case posterPath = "poster_path"
        case overview
        case title
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case video
    }

    init(id: Int, adult: Bool, backdropPath: String, originalIitle: String, voteAverage: Double, popularity: Double, posterPath: String, overview: String, title: String, originalLanguage: String, voteCount: Int, releaseDate: String, video: Bool) {
        self.id = id
        self.adult = adult
        self.backdropPath = backdropPath
        self.originalIitle = originalIitle
        self.voteAverage = voteAverage
        self.popularity = popularity
        self.posterPath = posterPath
        self.overview = overview
        self.title = title
        self.originalLanguage = originalLanguage
        self.voteCount = voteCount
        self.releaseDate = releaseDate
        self.video = video
    }
}
