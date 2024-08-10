import Foundation

extension Error {
    var errorCode:Int? {
        return (self as NSError).code
    }
}
