import Foundation

public enum Endpoint: Equatable {
    //Movies
    case popularMovies(page: Int)
}

extension Endpoint {
    var path: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        }
    }

    var queryItems: [APIQueryItem] {
        switch self {
        case .popularMovies(let page):
            return [.keyValue(key: "language", value: "en-US"), .keyValue(key: "page", value: String(page))]

//        default:
//            return []
        }
    }

    var requiresAccessToken: Bool {
        // For this movie app test all requests needs access token
        // Usually authentication requests do not need it, but we do not have auth requests here
        return true

    }
}

enum APIQueryItem {
    case keyValue(key: String, value: String)
    case date(date: Date)
}
