import UIKit

class UpdateViewController: UIViewController, HttpUtilsDelegate, ZipUtilsDelegate {

    @IBOutlet var lblCurrentCount: UILabel?
    @IBOutlet var lblNewCount: UILabel?
    @IBOutlet var btnUpdate: UIButton?
    @IBOutlet var procDownload: UIProgressView?
    @IBOutlet var tvLog: UITextView?

    var _update_file_size: Int64?
    
    override func viewWillAppear(animated: Bool) {
        UIUtils.setStatusBar(true)
        UIUtils.setNavBar(self.navigationController!.navigationBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = RIGHT_MENU_UPDATE
        self.btnUpdate!.setTitle(STR_DOWNLOAD_NA, forState:UIControlState.Normal)
        self.procDownload!.hidden = true
        self.btnUpdate!.hidden = false
        
        var build = (ApplicationUtils.getAppBuild() as NSString).integerValue
        var lastCard = DatabaseUtils.queryCardCount()
        var dbver = DatabaseUtils.getDatabaseVersion()
        var param = NSString(format: PARAM_UPDATE, build, lastCard, dbver)
        var hu = HttpUtils()
        hu.tag = 1
        hu.delegate = self
        hu.get("\(URL_UPDATE)?\(param)")
        self.lblCurrentCount!.text = NSString(format: STR_CARD_COUNT, lastCard)
        self.lblNewCount!.text = NSString(format: STR_CARD_COUNT, 0)
        // load update log
        var huLog = HttpUtils()
        huLog.tag = 3
        huLog.delegate = self
        huLog.get(URL_UPDATE_LOG)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func httpUtils(httpUtils: HttpUtils, receivedData data: NSData?) {
        switch (httpUtils.tag!) {
        case 1:
            self.extractUpdateInfo(data!)
        case 2:
            self.uncompressData(data!)
        case 3:
            self.showUpdateLog(data!)
        default:
            break
        }
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedFileSize fileSize: Int64) {
        if (httpUtils.tag == 2) {
            _update_file_size = fileSize
            self.procDownload!.hidden = false
        }
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedProgress progress: Int) {
        if (httpUtils.tag == 2) {
            var percent: Float = Float(progress) / Float(_update_file_size!)
            self.procDownload!.progress = percent
        }
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedError err: NSString) {
        
    }
    
    @IBAction func updateClicked(sender: AnyObject) {
        self.btnUpdate!.enabled = false
        self.procDownload!.progress = 0
        self.procDownload!.hidden = false
        var hu = HttpUtils()
        hu.tag = 2
        hu.delegate = self
        hu.get(URL_FILE_DATABASE)
    }
    
    func extractUpdateInfo(json: NSData) {
        var info = NSJSONSerialization.JSONObjectWithData(json, options:NSJSONReadingOptions.MutableLeaves, error:nil) as NSDictionary
        var newcard = (info.objectForKey("newcard") as NSString).integerValue
        if (newcard != 0) {
            self.btnUpdate!.setTitle(STR_DOWNLOAD_UPDATE, forState:UIControlState.Normal)
            self.btnUpdate!.enabled = true
            self.lblNewCount!.text = NSString(format: STR_CARD_COUNT, newcard)
        } else {
            self.btnUpdate!.setTitle(STR_DOWNLOAD_NA, forState:UIControlState.Normal)
            self.btnUpdate!.enabled = false
        }
    }
    
    func uncompressData(data: NSData) {
        FileUtils.writeFile(ZIP_NAME, savePath:"", fileData:data)
        var zu = ZipUtils()
        var archivePath = "\(FileUtils.getDocumentPath())/\(ZIP_NAME)"
        zu.archiveFile = archivePath
        zu.extractPath = FileUtils.getDocumentPath()
        zu.delegate = self
        zu.unzip()
    }
    
    func showUpdateLog(data: NSData) {
        var str = NSString(data: data, encoding:NSUTF8StringEncoding)
        self.tvLog!.text = str
    }
    
    func ziputils(ziputils: ZipUtils, unzipCompleted succ: Bool) {
        DatabaseUtils.openDatabase()
        self.btnUpdate!.setTitle(STR_DOWNLOAD_NA, forState:UIControlState.Normal)
        self.procDownload!.hidden = true
        self.btnUpdate!.enabled = false
        var lastCard = DatabaseUtils.queryLastCardId()
        self.lblCurrentCount!.text = NSString(format: STR_CARD_COUNT, lastCard)
        self.lblNewCount!.text = NSString(format: STR_CARD_COUNT, 0)
    }

    func zipWillUnzip() -> Bool {
        DatabaseUtils.closeDatabase()
        return true
    }

}
