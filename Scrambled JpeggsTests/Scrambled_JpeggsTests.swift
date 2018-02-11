import XCTest
import UIKit
@testable import Scrambled_Jpeggs

class Scrambled_JpeggsTests: XCTestCase {
    var game: ViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        game = storyboard.instantiateViewController(withIdentifier: "Main") as! ViewController
        let _ = game.view
    }
    
    override func tearDown() {
        game = nil
        super.tearDown()
    }
   
    
    func testMakeBlocks() {
        game.makeBlocks()
        XCTAssertEqual(game.blockArray.count, 15)
    }
    
    func testBlock1CenterPoint() {
        game.makeBlocks()
        XCTAssertEqual((game.blockArray[0] as! MyBlock).center, CGPoint(x: game.blockWidth/2, y: game.blockWidth/2))
        XCTAssertNotEqual((game.blockArray[0] as! MyBlock).center, CGPoint(x: game.blockWidth/3, y: game.blockWidth/3))
    }
    
    func testBlock2CenterPoint() {
        game.makeBlocks()
        XCTAssertEqual((game.blockArray[1] as! MyBlock).center, CGPoint(x: (1.5 * game.blockWidth), y: game.blockWidth/2))
        XCTAssertNotEqual((game.blockArray[1] as! MyBlock).center, CGPoint(x: game.blockWidth/3, y: game.blockWidth/3))
    }
    
    func testBlock6CenterPoint() {
        game.makeBlocks()
        XCTAssertEqual((game.blockArray[5] as! MyBlock).center, CGPoint(x: (1.5 * game.blockWidth), y: (1.5 * game.blockWidth)))
        XCTAssertNotEqual((game.blockArray[5] as! MyBlock).center, CGPoint(x: game.blockWidth/3, y: game.blockWidth/3))
    }
    
    func testCentersArrayContents() {
        game.makeBlocks()
        XCTAssertEqual(game.centersArray.count, 16)
    }
    
    func testCentersArrayBlock1() {
        game.makeBlocks()
        XCTAssertEqual((game.centersArray[0] as! CGPoint), CGPoint(x: game.blockWidth/2, y: game.blockWidth/2))
    }
    
    func testOriginalCenter() {
        game.makeBlocks()
        XCTAssertEqual((game.blockArray[0] as! MyBlock).originalCenter, CGPoint(x: game.blockWidth/2, y: game.blockWidth/2))
    }
    
    func testUserInteractionEnabled() {
        game.makeBlocks()
        for i in 0..<15 {
            XCTAssertTrue(((game.blockArray[i]) as! MyBlock).isUserInteractionEnabled)
        }
    }
    
    func testRandomnize() {
        game.makeBlocks()
        game.scramble()
        var blockHasChanged = false
        for anyBlock in game.blockArray{
            if (anyBlock as! MyBlock).center != (anyBlock as! MyBlock).originalCenter {
            blockHasChanged = true
            }
        }
        XCTAssertTrue(blockHasChanged)
    }
    
    func testEmptyBlock() {
        game.makeBlocks()
        game.scramble()
        var emptyBlockExists = false
        if game.empty != nil {
            emptyBlockExists = true
        }
        
        XCTAssertTrue(emptyBlockExists)
    }
    
    func testClearBlocks() {
        game.makeBlocks()
        game.clearBlocks()
        
        XCTAssertEqual(game.blockArray.count, 0)
    }
    
    func testCheckAllTilesInRightPlace() {
        game.makeBlocks()
        XCTAssertTrue(game.checkBlocks())
    }
    
    func testTilesInWrongPlace() {
        game.makeBlocks()
        game.scramble()
        XCTAssertFalse(game.checkBlocks())
    }
    
    func testFillInLastBlock() {
        game.makeBlocks()
        game.displayFinalBlock()
        XCTAssertEqual(game.blockArray.count, 16)
    }
    
    func testClickCounterIncrements() {
        game.makeBlocks()
        game.scramble()
        game.clickAction()
        XCTAssertEqual(game.clickCount,1)
    }
    
    func testBlocksCantMoveAfterWinning() {
        game.makeBlocks()
        game.gameOverLogic()
        XCTAssertFalse((game.blockArray[1] as! MyBlock).isUserInteractionEnabled)
    }
    
   
}


    


