import Foundation
import SwiftUI

public enum QuivFontSize {
    /// 96
    case h1
    /// 60
    case h2
    /// 48
    case h3
    /// 34
    case h4
    /// 24
    case h5
    /// 20
    case h6
    /// 16
    case subtitle1
    /// 14
    case subtitle2
    /// 16
    case body1
    /// 14
    case body2
    /// 14
    case button
    /// 12
    case caption
    /// 10
    case overline

    public var size: CGFloat {
        switch self {
        case .h1:
            return 96
        case .h2:
            return 60
        case .h3:
            return 48
        case .h4:
            return 34
        case .h5:
            return 24
        case .h6:
            return 20
        case .subtitle1:
            return 16
        case .subtitle2:
            return 14
        case .body1:
            return 16
        case .body2:
            return 14
        case .button:
            return 14
        case .caption:
            return 12
        case .overline:
            return 10
        }
    }
}

public extension Font {
    static func boldApp(size: QuivFontSize) -> Self {
        self.system(size: size.size, weight: .bold)
    }

    static func mediumApp(size: QuivFontSize) -> Self {
        self.system(size: size.size, weight: .medium)
    }

    static func regularApp(size: QuivFontSize) -> Self {
        self.system(size: size.size, weight: .regular)
    }

    static func lightApp(size: QuivFontSize) -> Self {
        self.system(size: size.size, weight: .light)
    }
}
