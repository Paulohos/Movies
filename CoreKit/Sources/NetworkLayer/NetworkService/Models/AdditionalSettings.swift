import Foundation

public enum AdditionalSettings {
    case appendHeader([[String: String]])
    case overrideHeader([[String: String]])
    case setTimeOut(Double)
}
