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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBlocks()
    }
    
    
    func makeBlocks() {
        blockArray = []
        
        gameViewWidth = gameView.frame.size.width
        blockWidth = gameViewWidth / 4
        
        xCenter = blockWidth / 2
        yCenter = blockWidth / 2
        
        for _ in 0..<4 {
            for _ in 0..<4 {
                let blockFrame : CGRect = CGRect(x: 0, y: 0, width: blockWidth, height: blockWidth)
                let block: UIImageView = UIImageView (frame: blockFrame)
                
                block.center = CGPoint(x: xCenter, y: yCenter)
                gameView.addSubview(block)
                blockArray.add(block)
                
                xCenter = xCenter + blockWidth
            }
            xCenter = blockWidth / 2
            yCenter = yCenter + blockWidth
        }
    }


}

