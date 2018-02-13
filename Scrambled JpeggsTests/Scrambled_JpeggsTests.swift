import XCTest
import UIKit
import AVFoundation
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
   
    // #makeBlocks tests
    
    func testMakeBlocks4x4() {
        game.makeBlocks()
        XCTAssertEqual(game.blockArray.count, 15)
    }
    
    func testMakeBlocks3x3() {
        game.rowSize = 3
        game.makeBlocks()
        XCTAssertEqual(game.blockArray.count, 8)
    }
    
    func testMakeBlocks5x5() {
        game.rowSize = 5
        game.makeBlocks()
        XCTAssertEqual(game.blockArray.count, 24)
    }
    
    func testFirstBlockCenterPoint() {
        game.makeBlocks()
        XCTAssertEqual((game.blockArray[0] as! MyBlock).center, CGPoint(x: game.blockWidth/2, y: game.blockWidth/2))
    }
    
    func testEndOfRowOneBlock3x3() {
        game.rowSize = 3
        game.makeBlocks()
        XCTAssertEqual((game.blockArray[2] as! MyBlock).center, CGPoint(x: (2.5 * game.blockWidth), y: game.blockWidth/2))
    }
    
    func testEndOfRowOneBlock4x4() {
        game.rowSize = 4
        game.makeBlocks()
        XCTAssertEqual((game.blockArray[3] as! MyBlock).center, CGPoint(x: (3.5 * game.blockWidth), y: game.blockWidth/2))
    }
    
//    func testEndOfRowOneBlock5x5() {
//        game.rowSize = 5
//        game.makeBlocks()
//        XCTAssertEqual((game.blockArray[4] as! MyBlock).center, CGPoint(x: (4.5 * game.blockWidth), y: game.blockWidth/2))
//    }
    
    func testLastBlockCenter3x3() {
        game.rowSize = 3
        game.makeBlocks()
        XCTAssertEqual((game.blockArray[7] as! MyBlock).center, CGPoint(x: (1.5 * game.blockWidth), y: (2.5 * game.blockWidth)))
    }
    
    func testLastBlockCenter4x4() {
        game.rowSize = 4
        game.makeBlocks()
        XCTAssertEqual((game.blockArray[14] as! MyBlock).center, CGPoint(x: (2.5 * game.blockWidth), y: (3.5 * game.blockWidth)))
    }
    
//    func testLastBlockCenter5x5() {
//        game.rowSize = 5
//        game.makeBlocks()
//        XCTAssertEqual((game.blockArray[23] as! MyBlock).center, CGPoint(x: (3.5 * game.blockWidth), y: (4.5 * game.blockWidth)))
//    }
    
    func testFinalBlock3x3() {
        game.rowSize = 3
        game.makeBlocks()
        XCTAssertEqual(game.finalBlock.center, CGPoint(x: (2.5 * game.blockWidth), y: (2.5 * game.blockWidth)))
    }
    
    func testFinalBlock4x4() {
        game.rowSize = 4
        game.makeBlocks()
        XCTAssertEqual(game.finalBlock.center, CGPoint(x: (3.5 * game.blockWidth), y: (3.5 * game.blockWidth)))
    }
    
//    func testFinalBlock5x5() {
//        game.rowSize = 5
//        game.makeBlocks()
//        XCTAssertEqual(game.finalBlock.center, CGPoint(x: (4.5 * game.blockWidth), y: (4.5 * game.blockWidth)))
//    }
    
    func testCentersArrayContents3x3() {
        game.rowSize = 3
        game.makeBlocks()
        XCTAssertEqual(game.centersArray.count, 9)
    }
    
    func testCentersArrayContents4x4() {
        game.rowSize = 4
        game.makeBlocks()
        XCTAssertEqual(game.centersArray.count, 16)
    }
    
    func testCentersArrayContents5x5() {
        game.rowSize = 5
        game.makeBlocks()
        XCTAssertEqual(game.centersArray.count, 25)
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
        for i in 0..<game.visibleBlocks {
            XCTAssertTrue(((game.blockArray[i]) as! MyBlock).isUserInteractionEnabled)
        }
    }
    
    // #slice tests
    
    func testImageSplitIntoCorrectAmount3x3() {
        game.rowSize = 3
        let imageSet = game.slice(image: game.gameImage, into: game.rowSize)
        XCTAssertEqual(imageSet.count, 9)
    }
    
    func testImageSplitIntoCorrectAmount4x4() {
        game.rowSize = 4
        let imageSet = game.slice(image: game.gameImage, into: game.rowSize)
        XCTAssertEqual(imageSet.count, 16)
    }
    
    func testImageSplitIntoCorrectAmount5x5() {
        game.rowSize = 5
        let imageSet = game.slice(image: game.gameImage, into: game.rowSize)
        XCTAssertEqual(imageSet.count, 25)
    }
    
    // #playBackgroundMusic tests
    
    func testBackgroundMusicPlaysOnViewLoad() {
        XCTAssertTrue(game.audioPlayer.isPlaying)
    }
    
    // #toggleMusic tests
    
    func testMusicTogglesOff() {
        game.muteToggle.setOn(false, animated: false)
        game.toggleMusic(switchState: game.muteToggle)
        XCTAssertFalse(game.audioPlayer.isPlaying)
    }
    
    func testMusicTogglesOn() {
        game.muteToggle.setOn(true, animated: false)
        game.toggleMusic(switchState: game.muteToggle)
        XCTAssertTrue(game.audioPlayer.isPlaying)
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
        game.checkBlocks()
        XCTAssertTrue(game.gameOver)
    }
    
    func testTilesInWrongPlace() {
        game.makeBlocks()
        game.scramble()
        game.checkBlocks()
        XCTAssertFalse(game.gameOver)
    }
    
    func testFillInLastBlock() {
        game.makeBlocks()
        game.displayFinalBlock()
        XCTAssertEqual(game.gameView.subviews.count, 31)
    }
    
    func testClickCounterIncrements() {
        game.makeBlocks()
        game.scramble()
        game.clickAction()
        XCTAssertEqual(game.clickCount,1)
    }
    
    func testClickCounterIncrementsLabel() {
        game.makeBlocks()
        game.scramble()
        game.clickAction()
        XCTAssertEqual(game.clickCounterLabel.text,"1")
    }
    
    func testClickCounterResets() {
        game.makeBlocks()
        game.scramble()
        game.clickAction()
        game.clickAction()
        game.ResetButton((Any).self)
        XCTAssertEqual(game.clickCount,0)
    }
    
    func testClickCounterResetsLabel() {
        game.makeBlocks()
        game.scramble()
        game.clickAction()
        game.clickAction()
        game.ResetButton((Any).self)
        XCTAssertEqual(game.clickCounterLabel.text,"0")
    }
    
    func testClickCounterIncrementsAfterReset() {
        game.makeBlocks()
        game.scramble()
        game.clickAction()
        game.ResetButton((Any).self)
        game.clickAction()
        game.clickAction()
        XCTAssertEqual(game.clickCount,2)
    }
    
    func testClickCounterIncrementsLabelAfterReset() {
        game.makeBlocks()
        game.scramble()
        game.clickAction()
        game.ResetButton((Any).self)
        game.clickAction()
        game.clickAction()
        XCTAssertEqual(game.clickCounterLabel.text,"2")
    }
    
    func testBlocksCanBeDisabled() {
        game.makeBlocks()
        game.setUserInteractionStateForAllBlocks(state: false)
        XCTAssertFalse((game.blockArray[1] as! MyBlock).isUserInteractionEnabled)
    }
    
    func testBlocksCanBeEnabled() {
        game.makeBlocks()
        game.setUserInteractionStateForAllBlocks(state: false)
        game.setUserInteractionStateForAllBlocks(state: true)
        XCTAssertTrue((game.blockArray[1] as! MyBlock).isUserInteractionEnabled)
    }
    
    
    
}


    


