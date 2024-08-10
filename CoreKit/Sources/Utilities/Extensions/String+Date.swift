import Foundation

extension String {
    /// Convert string to date
    public func toDate(dateFormat: Date.DateFormatType) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.stringFormat
        dateFormatter.locale = .current
        return dateFormatter.date(from: self)
    }
}
