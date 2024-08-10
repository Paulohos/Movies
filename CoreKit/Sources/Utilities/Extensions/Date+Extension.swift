import Foundation

extension Date {

    /// Enum with date formatters type do convert string to date
    public enum DateFormatType {
        /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.453+01:00
        case isoRetrievedFromServer

        /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSS'Z" i.e. 1997-07-16T19:20:30.453Z
        case isoServerFormat

        /// The formatter "dd/MM/yyyy" i.e. 01/12/1995
        case birthDateFormat

        /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
        case isoDate

        /// The formatter "dd/MM" i.e. 01/12
        case dayMonth

        /// The ISO8601 formatted year "dd" i.e. 02
        case isoDay

        /// The ISO8601 formatted year "MM" i.e. 10
        case isoMonth

        /// The ISO8601 formatted year "yyyy" i.e. 1997
        case isoYear

        /// The local formatted  time "hh:mm a" i.e. 07:20 am
        case localTimeWithNoon

        /// The formatter "MMMM" i.e May
        case monthDescription

        /// The formatter "EEEE" Friday
        case dayOfWeek

        /// The card expiration date formatter "MM/yy"
        case cardExpiration

        /// A custom date format string
        case custom(String)

        var stringFormat: String {
            let is24Hour = Date.is24Hour ?? false
            switch self {
            case .isoServerFormat:
                return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"

            case .isoRetrievedFromServer:
                return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

            case .birthDateFormat:
                return "dd/MM/yyyy"

            case .isoDate:
                return "yyyy-MM-dd"

            case .dayMonth:
                return "dd/MM"

            case .isoDay:
                return "dd"

            case .isoMonth:
                return "MM"

            case .isoYear:
                return "yyyy"

            case .localTimeWithNoon:
                return is24Hour ? "HH:mm" : "hh:mm a"

            case .monthDescription:
                return "MMMM"

            case .dayOfWeek:
                return "EEEE"

            case .cardExpiration:
                return "MM/yy"

            case .custom(let customFormat):
                return customFormat
            }
        }
    }

    public var yearIn: Int {
        Calendar.current.component(.year, from: self)
    }
}

public extension Date {
    static var locale = Locale.current

    /// Detect 24-hour clock in  iOS `(20:00 or 8:00 PM)`
    static var is24Hour: Bool? {
        guard
            let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)
        else { return nil }

        return dateFormat.firstIndex(of: "a") == nil
    }
}
