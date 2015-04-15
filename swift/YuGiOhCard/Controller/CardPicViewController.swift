import UIKit

class CardPicViewController: UIViewController, HttpUtilsDelegate {

    @IBOutlet var imgCard: UIImageView?
    @IBOutlet var btnDownload: UIButton?
    @IBOutlet var aivDownload: UIActivityIndicatorView?
    
    var _img_path: String?
    var card: CardItem?
    
    var inited = false
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (!inited) {
            inited = true
            var v: UIView?
            for temp in self.view.subviews {
                v = temp as? UIView
                if (v is UIImageView) || (v is UIButton) || (v is UIActivityIndicatorView) {
                    UIUtils.scaleComponent(v!)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inited = false
        _img_path = "image"
        self.card = (self.tabBarController! as! CardViewController).card
        var cardImgName = "\(self.card!._id).jpg"
        var exists = FileUtils.fileExists(cardImgName, filePath:_img_path!)
        if (exists) {
            self.loadImage(FileUtils.readFile(cardImgName, loadPath:_img_path!)!)
        } else {
            self.imgCard!.hidden = true
            self.btnDownload!.hidden = false
            self.aivDownload!.hidden = true
            self.btnDownload!.addTarget(self, action:"downloadClick:", forControlEvents:UIControlEvents.TouchDown)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func downloadClick(sender: AnyObject) {
        self.aivDownload!.hidden = false
        self.btnDownload!.hidden = true
        var hu = HttpUtils()
        hu.delegate = self
        var url = NSString(format: URL_CARD_IMAGE, self.card!._id) as String
        hu.get(url)
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedData data: NSData?) {
        if (data != nil) {
            var fileName = "\(self.card!._id).jpg"
            FileUtils.writeFile(fileName, savePath:_img_path!, fileData:data!)
            self.loadImage(data!)
        }
    }

    func httpUtils(httpUtils: HttpUtils, receivedError err: NSString) {
        self.imgCard!.hidden = true
        self.btnDownload!.hidden = false
        self.aivDownload!.hidden = true
    }
    
    func loadImage(data: NSData) {
        self.imgCard!.hidden = false
        self.btnDownload!.hidden = true
        self.aivDownload!.hidden = true
        self.imgCard!.image = UIImage(data: data)
    }
}
