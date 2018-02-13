import XCTest

class Scrambled_JpeggsUITests: XCTestCase {
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSwipeButtonPlay() {
        let firstSwitch = app.switches.element(boundBy: 0)
        XCTAssertEqual(firstSwitch.value as! String, "1")
    }
    
    func testSwipeButtonMute() {
        let secondSwitch = app.switches.element(boundBy: 0)
        XCUIApplication().switches["1"].tap()
        XCTAssertEqual(secondSwitch.value as! String, "0")
    }
    
    func testEasyButton() {
        let environment = app.segmentedControls.element(boundBy: 0);
        app/*@START_MENU_TOKEN@*/.buttons["Easy"]/*[[".segmentedControls.buttons[\"Easy\"]",".buttons[\"Easy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(environment.buttons.element(boundBy:0).isSelected, "Easy");
        
    }
    
    func testMediumButton() {
        let environment = app.segmentedControls.element(boundBy: 0);
        XCTAssertTrue(environment.buttons.element(boundBy:1).isSelected, "Medium");
    }
    
    func testHardButton() {
        let environment = app.segmentedControls.element(boundBy: 0);
        app.buttons["Hard"].tap()
        XCTAssertTrue(environment.buttons.element(boundBy:2).isSelected, "Hard");
    }
    
    func testMoveCounterStartsAsZero() {
        let counterLabel = app.staticTexts["0"]
        XCTAssertEqual("0", counterLabel.label)
    }
    
}
