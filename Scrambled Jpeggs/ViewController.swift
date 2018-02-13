import UIKit
import MobileCoreServices
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var clickCounterLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var showSolutionButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var difficultyControl: UISegmentedControl!
    @IBOutlet weak var muteToggle: UISwitch!
    
    var gameViewWidth : CGFloat!
    var blockWidth : CGFloat!
    var visibleBlocks : Int!
    var rowSize : Int!
    var xCenter : CGFloat!
    var yCenter : CGFloat!
    var finalBlock : MyBlock!
    var blockArray: NSMutableArray = []
    var centersArray: NSMutableArray = []
    var images: [UIImage] = []
    var gameImage : UIImage!
    var empty: CGPoint!
    var clickCount : Int = 0
    var audioPlayer = AVAudioPlayer()
    var newPic: Bool?
    var gameOver : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameImage = #imageLiteral(resourceName: "square-deer")
        rowSize = 4
        difficultyControl.selectedSegmentIndex =  1
        scaleToScreen()
        makeBlocks()
        playBackgroundMusic()
        muteToggle.addTarget(self, action: #selector(toggleMusic), for: UIControlEvents.valueChanged)
        self.ResetButton(Any.self)
    }
    
    func scaleToScreen() {
        gameView.frame.size.height = gameView.frame.size.width
        timerLabel.frame.size.width = gameView.frame.size.width
        uploadImageButton.frame.size.width = (gameView.frame.size.width / 2) - 5
        uploadImageButton.frame.size.width = (gameView.frame.size.width / 2) - 5
        resetButton.frame.size.width = gameView.frame.size.width
    }
    
    func makeBlocks() {
        blockArray = []
        centersArray = []
        visibleBlocks = (rowSize * rowSize) - 1
        images = slice(image: gameImage, into:rowSize)
        
        gameViewWidth = gameView.frame.size.width
        blockWidth = gameViewWidth / CGFloat(rowSize)
        
        xCenter = blockWidth / 2
        yCenter = blockWidth / 2
        
        var picNum = 0
        
        for _ in 0..<rowSize {
            for _ in 0..<rowSize {
                let blockFrame : CGRect = CGRect(x: 0, y: 0, width: blockWidth, height: blockWidth)
                let block: MyBlock = MyBlock (frame: blockFrame)
                let thisCenter : CGPoint = CGPoint(x: xCenter, y: yCenter)
                
                block.isUserInteractionEnabled = true
                block.image = images[picNum]
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
        
        finalBlock = blockArray[visibleBlocks] as! MyBlock
        finalBlock.removeFromSuperview()
        blockArray.removeObject(identicalTo: finalBlock)
    }
    
    func slice(image: UIImage, into howMany: Int) -> [UIImage] {
        
        let width: CGFloat = image.size.width
        let height: CGFloat = image.size.height
        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))
        let scale = Int(image.scale)
        var imageSections = [UIImage]()
        let cgImage = image.cgImage!
        var adjustedHeight = tileHeight
        
        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                imageSections.append(UIImage(cgImage: tileCgImage, scale: image.scale, orientation: image.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return imageSections
    }
    
    func playBackgroundMusic() {
        let aSound = NSDataAsset(name: "background_music")
        do {
            audioPlayer = try AVAudioPlayer(data:(aSound?.data)!, fileTypeHint: "mp3")
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("Cannot play the file")
        }
    }
    
    @objc func toggleMusic(switchState: UISwitch) {
        if switchState.isOn {
            audioPlayer.play()
        } else {
            audioPlayer.stop()
        }
    }
    
    @IBAction func ResetButton(_ sender: Any) {
        clickCount = 0
        clickCounterLabel.text = String.init(format: "%d", clickCount)
        finalBlock.removeFromSuperview()
        gameOver = false
        setUserInteractionStateForAllBlocks(state: true)
        scramble()
    }
    
    @IBAction func showEndAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Congrats", message: "You did it in \(clickCount) moves!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func scramble() {
        let temporaryCentersArray: NSMutableArray = centersArray.mutableCopy() as! NSMutableArray
        for anyBlock in blockArray {
            let randomIndex: Int = Int(arc4random()) % temporaryCentersArray.count
            let randomCenter: CGPoint = temporaryCentersArray[randomIndex] as! CGPoint
            (anyBlock as! MyBlock).center = randomCenter
            temporaryCentersArray.removeObject(at: randomIndex)
        }
        empty = temporaryCentersArray[0] as! CGPoint
    }
    
    func clearBlocks(){
        for i in 0..<visibleBlocks {
            (blockArray[i] as! MyBlock).removeFromSuperview()
        }
        blockArray = []
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myTouch : UITouch = touches.first!
        if (blockArray.contains(myTouch.view as Any))        {
            
            let touchView: MyBlock = (myTouch.view)! as! MyBlock
            
            let xOffset: CGFloat = touchView.center.x - empty.x
            let yOffset: CGFloat = touchView.center.y - empty.y
            
            let distanceBetweenCenters : CGFloat = sqrt(pow(xOffset, 2) + pow(yOffset, 2))
           
            if (Int(distanceBetweenCenters) == Int(blockWidth)) {
                let temporaryCenter : CGPoint = touchView.center
                
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.2)
                touchView.center = empty
                UIView.commitAnimations()
                self.clickAction()
                empty = temporaryCenter
                
                checkBlocks()
                if gameOver == true {
                    setUserInteractionStateForAllBlocks(state: false)
                    displayFinalBlock()
                    displayGameOverAlert()
                }
            }
        }
    }
    
    @objc func clickAction() {
        clickCount += 1
        clickCounterLabel.text = String.init(format: "%d", clickCount)
    }
    
    func checkBlocks() {
        var correctBlockCounter = 0
        
        for i in 0..<visibleBlocks {
            if (blockArray[i] as! MyBlock).center == (blockArray[i] as! MyBlock).originalCenter {
                correctBlockCounter += 1
            }
        }
        if correctBlockCounter == visibleBlocks {
            gameOver = true
        } else {
            gameOver = false
        }
    }
    
    func setUserInteractionStateForAllBlocks(state: Bool) {
        for i in 0..<visibleBlocks {
            (blockArray[i] as! MyBlock).isUserInteractionEnabled = state
        }
    }
    
    func displayFinalBlock() {
        gameView.addSubview(finalBlock)
    }
    
    func displayGameOverAlert() {
        self.showEndAlert(Any.self)
    }
    
    @IBAction func showSolutionTapped(_ sender: Any) {
        if (gameOver == false) {
            let tempCentersArray : NSMutableArray = []
            (self.finalBlock).center = self.empty
        
            for i in 0..<visibleBlocks {
                tempCentersArray.add((blockArray[i] as! MyBlock).center)
            }
        
            UIView.animate(withDuration: 1, animations: {
                for i in 0..<self.visibleBlocks {
                    (self.self.blockArray[i] as! MyBlock).center = (self.blockArray[i] as! MyBlock).originalCenter
                }
                self.gameView.addSubview(self.finalBlock)
                (self.finalBlock).center = (self.finalBlock).originalCenter
            }) { _ in
                UIView.animate(withDuration: 2, delay: 3, animations: {
                    for i in 0..<self.visibleBlocks {
                        (self.blockArray[i] as! MyBlock).center = (tempCentersArray[i] as! CGPoint)
                    }
                    (self.finalBlock).center = self.empty
                }) { _ in
                    UIView.animate(withDuration: 2, animations: {
                        self.finalBlock.removeFromSuperview()
                        (self.finalBlock).center = (self.finalBlock).originalCenter
                    })
                }
            }
        }
    }
    
    @IBAction func difficultyTapped(_ sender: Any) {
        clearBlocks()
        switch difficultyControl.selectedSegmentIndex
        {
            case 0:
            rowSize = 3
            case 1:
            rowSize = 4
            case 2:
            rowSize = 5
        default:
            rowSize = 4
        }
        visibleBlocks = (rowSize * rowSize) - 1
        makeBlocks()
        self.ResetButton(Any.self)
    }
    
    @IBAction func uploadImageTaped(_ sender: Any) {

        let myAlert = UIAlertController(title: "Select image from", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newPic = true
            }
        }
        
        let cameraRollAction = UIAlertAction(title: "Camera Roll", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newPic = false
            }
        }
        
        myAlert.addAction(cameraAction)
        myAlert.addAction(cameraRollAction)
        self.present(myAlert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            gameImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            clearBlocks()
            makeBlocks()
            self.ResetButton(Any.self)
            
            if newPic == true {
                UIImageWriteToSavedPhotosAlbum(gameImage, self, #selector(imageError), nil)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageError (image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let alert = UIAlertController(title: "Save failed", message: "Failed to save image", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

class MyBlock : UIImageView {
    var originalCenter: CGPoint!
}

