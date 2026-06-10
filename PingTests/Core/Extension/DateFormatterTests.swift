import XCTest
@testable import Ping

final class DateFormatterTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFormattedDateReturnsExpectedValue() {
        //ARRANGE
        let calender = Calendar(identifier: .gregorian)
        let date = calender.date(from: DateComponents(year: 2026, month: 1, day: 1))
        
        //ACT
        let result = date?.formattedDate
        
        //ASSERT
        XCTAssertEqual(result, "01 Jan 2026")
    }
    
    func testDayNameReturnsExpectedValue() {
        //ARRANGE
        let calender = Calendar(identifier: .gregorian)
        let date = calender.date(from: DateComponents(year: 2026, month: 1, day: 1))

        //ACT
        let result = date?.dayName
        
        //ASSERT
        XCTAssertEqual(result, "Thursday")

    }
    
    func testFormattedTimeReturnsExpectedValue() {
        //ARRANGE
        let calender = Calendar(identifier: .gregorian)
        let date = calender.date(from: DateComponents(year: 2026, month: 1, day: 1, hour: 18, minute: 30))

        //ACT
        let result = date?.formattedTime
        
        //ASSERT
        XCTAssertEqual(result, "18:30")


    }


}
