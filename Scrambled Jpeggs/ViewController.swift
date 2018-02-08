import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func ResetButton(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBlocks()
    }
    
    
    func makeBlocks() -> String {
        return "true"
    }


}

