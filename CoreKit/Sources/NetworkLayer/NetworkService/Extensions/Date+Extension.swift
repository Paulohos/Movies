import Foundation

extension Date {
    enum LocaleType: String {
        /// "pt_BR"
        case ptBr = "pt_BR"
    }
    /// This method is used to send the a date in the correct format to the sever
    /// The server will always receive the date in the UTC 0(zero)
    func convertToUTC() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        // Forcing the clock conversion to 24 hour Time
        // We need to do that because some places like USA uses a system clock of 12 hours Time
        // And because of that we're facing some problems to convert the dates
        // Because de server always receive and send a 24 hours Time date i.e. "2023-07-21T17:19:29.744Z".
        formatter.locale = Locale(identifier: LocaleType.ptBr.rawValue)
        // Forcing data to UTC 0(zero)
        // Server always receive the dates on the UTC 0
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
}
