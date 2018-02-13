import XCTest

class Scrambled_JpeggsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
    
        continueAfterFailure = false
       
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSwipeButtonPlay() {
        let app = XCUIApplication()
        let firstSwitch = app.switches.element(boundBy: 0)
        XCTAssertEqual(firstSwitch.value as! String, "1")
    }
    
    func testSwipeButtonMute() {
        let app = XCUIApplication()
        let secondSwitch = app.switches.element(boundBy: 0)
        XCUIApplication().switches["1"].tap()
        XCTAssertEqual(secondSwitch.value as! String, "0")
    }
    
}
