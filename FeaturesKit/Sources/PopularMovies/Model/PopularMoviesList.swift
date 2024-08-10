import Foundation

public struct PopularMoviesResponse: Decodable {
    var results: [PopularMoviesList]
    var totalPages: Int

    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([PopularMoviesList].self, forKey: .results)
        self.totalPages = try container.decode(Int.self, forKey: .totalPages)
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.adult = try container.decode(Bool.self, forKey: .adult)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.originalIitle = try container.decode(String.self, forKey: .originalIitle)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.title = try container.decode(String.self, forKey: .title)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.video = try container.decode(Bool.self, forKey: .video)
    }

}
