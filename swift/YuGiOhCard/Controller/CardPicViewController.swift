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
                    UIUtils.scaleComponent(view: temp)
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
        let exists = FileUtils.fileExists(fileName: cardImgName, filePath:_img_path!)
        if (exists) {
            self.loadImage(data: FileUtils.readFile(fileName: cardImgName, loadPath:_img_path!)!)
        } else {
            self.imgCard!.isHidden = true
            self.btnDownload!.isHidden = false
            self.aivDownload!.isHidden = true
            self.btnDownload!.addTarget(self, action:#selector(downloadClick(sender:)), for:UIControlEvents.touchDown)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func downloadClick(sender: AnyObject) {
        self.aivDownload!.isHidden = false
        self.btnDownload!.isHidden = true
        let hu = HttpUtils()
        hu.delegate = self
        let url = NSString(format: URL_CARD_IMAGE, self.card!._id) as String
        hu.get(url: url)
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedData data: NSData?) {
        if (data != nil) {
            let fileName = "\(self.card!._id).jpg"
            FileUtils.writeFile(fileName: fileName, savePath:_img_path!, fileData:data!)
            self.loadImage(data: data!)
        }
    }

    func httpUtils(httpUtils: HttpUtils, receivedError err: NSString) {
        self.imgCard!.isHidden = true
        self.btnDownload!.isHidden = false
        self.aivDownload!.isHidden = true
    }
    
    func loadImage(data: NSData) {
        self.imgCard!.isHidden = false
        self.btnDownload!.isHidden = true
        self.aivDownload!.isHidden = true
        self.imgCard!.image = UIImage(data: data as Data)
    }
}
