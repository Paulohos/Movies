import Foundation

extension Date {

    /// Enum with date formatters type do convert string to date
    public enum DateFormatType {
        /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
        case isoDate

        var stringFormat: String {
            switch self {
            case .isoDate:
                return "yyyy-MM-dd"
            }
        }
    }

    public var yearIn: Int {
        Calendar.current.component(.year, from: self)
    }
}

