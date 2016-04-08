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
            for temp in self.view.subviews {
                if (temp is UIImageView) || (temp is UIButton) || (temp is UIActivityIndicatorView) {
                    UIUtils.scaleComponent(temp)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inited = false
        _img_path = "image"
        self.card = (self.tabBarController! as! CardViewController).card
        let cardImgName = "\(self.card!._id).jpg"
        let exists = FileUtils.fileExists(cardImgName, filePath:_img_path!)
        if (exists) {
            self.loadImage(FileUtils.readFile(cardImgName, loadPath:_img_path!)!)
        } else {
            self.imgCard!.hidden = true
            self.btnDownload!.hidden = false
            self.aivDownload!.hidden = true
            self.btnDownload!.addTarget(self, action:#selector(CardPicViewController.downloadClick(_:)), forControlEvents:UIControlEvents.TouchDown)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func downloadClick(sender: AnyObject) {
        self.aivDownload!.hidden = false
        self.btnDownload!.hidden = true
        let hu = HttpUtils()
        hu.delegate = self
        let url = NSString(format: URL_CARD_IMAGE, self.card!._id) as String
        hu.get(url)
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedData data: NSData?) {
        if (data != nil) {
            let fileName = "\(self.card!._id).jpg"
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
