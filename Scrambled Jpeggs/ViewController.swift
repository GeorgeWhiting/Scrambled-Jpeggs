import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func ResetButton(_ sender: Any) {
    }
    
    var blockArray: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBlocks()
    }
    
    
    func makeBlocks() {
        blockArray = []
        
        for _ in 0..<4 {
            for _ in 0..<4 {
                let blockFrame : CGRect = CGRect(x: 0, y: 0, width: 10, height: 10)
                let block: UIImageView = UIImageView (frame: blockFrame)
                
                gameView.addSubview(block)
                blockArray.add(block)
            }
        }
    }


}

