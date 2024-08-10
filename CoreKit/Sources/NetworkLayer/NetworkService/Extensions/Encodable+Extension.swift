import Foundation

extension Encodable {
    var asData: Data? { try? JSONEncoder().encode(self) }
}
