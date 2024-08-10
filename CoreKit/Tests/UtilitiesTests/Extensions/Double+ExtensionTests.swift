import XCTest

@testable import Utilities

final class DoubleExtensionTests: XCTestCase {

    func testRoudingDouble() {
        XCTAssertEqual(10.888888.rounded(), "10,89")
        XCTAssertEqual(7.777777.rounded(4,4), "7,7778")
    }
}
