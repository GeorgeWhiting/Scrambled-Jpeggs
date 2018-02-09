import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    var newPic: Bool?
    
    @IBOutlet weak var imageView: UIImageView!
    
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
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            imageView.image = image
            
            if newPic == true {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageError), nil)
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

