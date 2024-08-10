import XCTest

@testable import Utilities

final class DateExtensionTests: XCTestCase {
    
    func testDateFormatType() {
        XCTAssertEqual(Date.DateFormatType.isoDate.stringFormat, "yyyy-MM-dd")
    }

    func testGetYearFromDate() {
        let date = "2024-08-10".toDate(dateFormat: .isoDate)!
        XCTAssertEqual(date.yearIn, 2024)
    }
}
