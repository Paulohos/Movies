import XCTest

@testable import Utilities

final class StringDateTests: XCTestCase {

    func testConvertStringToDate() {
        XCTAssertNotNil("2024-08-10".toDate(dateFormat: .isoDate))
    }
}
