import Foundation

extension URL {
    func addQueryItems(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        // Create array of existing query items
        urlComponents.queryItems = queryItems
        // Returns the url from new url components
        return urlComponents.url
    }
}
