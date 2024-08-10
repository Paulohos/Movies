import Scheme

public struct DefaultError: Decodable, Error, Equatable {
    public var code: Int
    public var title: String
    public var message: String

    public init(code: Int?, title: String?, message: String?) {
        self.code = code ?? .zero
        self.title = title ?? ""
        self.message = message ?? ""
    }

    enum CodingKeys: CodingKey {
        case code
        case title
        case message
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(Int.self, forKey: .code) ?? 0
        self.title = try container.decode(String.self, forKey: .title)
        self.message = try container.decode(String.self, forKey: .message)
    }

    public init() {
        code = .zero
        title = L10n.Localizable.MessageError.Default.title
        message = L10n.Localizable.MessageError.Default.message
    }
}

extension DefaultError {
    public static var defaultError: Self {
        DefaultError(
            code: 500,
            title: L10n.Localizable.MessageError.Default.title,
            message: L10n.Localizable.MessageError.Default.message
        )
    }

    public static func defaultError(statusCode: Int) -> Self {
        DefaultError(
            code: statusCode,
            title: L10n.Localizable.MessageError.Default.title,
            message: L10n.Localizable.MessageError.Default.message
        )
    }
}
