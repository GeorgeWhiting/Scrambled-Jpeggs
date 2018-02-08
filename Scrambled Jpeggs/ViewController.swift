import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func ResetButton(_ sender: Any) {
    }
    
    var gameViewWidth : CGFloat!
    var blockWidth : CGFloat!
    
    var xCenter : CGFloat!
    var yCenter : CGFloat!
    
    var blockArray: NSMutableArray = []
    var centersArray: NSMutableArray = []
    var picNum : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBlocks()
    }
    
    
    func makeBlocks() {
        blockArray = []
        centersArray = []
        
        gameViewWidth = gameView.frame.size.width
        blockWidth = gameViewWidth / 4
        
        xCenter = blockWidth / 2
        yCenter = blockWidth / 2
        
        picNum = 0
        
        let image = [#imageLiteral(resourceName: "Image1"), #imageLiteral(resourceName: "Image2"), #imageLiteral(resourceName: "Image3"), #imageLiteral(resourceName: "Image4"), #imageLiteral(resourceName: "Image5"), #imageLiteral(resourceName: "Image6"), #imageLiteral(resourceName: "Image7"), #imageLiteral(resourceName: "Image8"), #imageLiteral(resourceName: "Image9"), #imageLiteral(resourceName: "Image10"), #imageLiteral(resourceName: "Image11"), #imageLiteral(resourceName: "Image12"), #imageLiteral(resourceName: "Image13"), #imageLiteral(resourceName: "Image14"), #imageLiteral(resourceName: "Image15"), #imageLiteral(resourceName: "Image16")]
        
        for _ in 0..<4 {
            for _ in 0..<4 {
                let blockFrame : CGRect = CGRect(x: 0, y: 0, width: blockWidth, height: blockWidth)
                let block: MyBlock = MyBlock (frame: blockFrame)
                let thisCenter : CGPoint = CGPoint(x: xCenter, y: yCenter)
                
                block.isUserInteractionEnabled = true
                block.image = image[picNum]
                picNum += 1
                
                block.center = thisCenter
                block.originalCenter = thisCenter
                gameView.addSubview(block)
                blockArray.add(block)
                
                xCenter = xCenter + blockWidth
                centersArray.add(thisCenter)
            }
            xCenter = blockWidth / 2
            yCenter = yCenter + blockWidth
        }
        
        let finalBlock : MyBlock = blockArray[15] as! MyBlock
        finalBlock.removeFromSuperview()
        blockArray.removeObject(at: 15)
        
    }


}
class MyBlock : UIImageView {
    var originalCenter: CGPoint!
}

