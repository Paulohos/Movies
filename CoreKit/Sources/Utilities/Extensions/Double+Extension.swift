import Foundation

extension Double {
    public func rounded(_ minimumFractionDigits: Int = 2, _ maximumFractionDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits

        return formatter.string(for: self)
    }
}
