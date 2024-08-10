import Foundation

public enum L10n {

    public enum Localizable {
        public enum MessageError {
          public enum Default {
            /// We are experiencing instability, please try later.
            public static let message = L10n.tr("Localizable", "messageError.default.message")
            /// Oops... Something went wrong
            public static let title = L10n.tr("Localizable", "messageError.default.title")
          }
        }

        /// Try again
        public static let tryAgain = L10n.tr("Localizable", "tryAgain")
        /// Popular
        public static let popular = L10n.tr("Localizable", "popular")

        public enum Movie {
            public enum Detail {
                /// Watch movie
                public static let watch = L10n.tr("Localizable", "movie.detail.watch")
                /// Trailer
                public static let trailer = L10n.tr("Localizable", "movie.detail.trailer")
            }
        }
    }
}

private extension L10n {
    static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

private final class BundleToken {}
