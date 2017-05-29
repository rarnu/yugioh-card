import UIKit

class UpdateViewController: UIViewController, HttpUtilsDelegate, ZipUtilsDelegate {

    @IBOutlet var lblCurrentCount: UILabel?
    @IBOutlet var lblNewCount: UILabel?
    @IBOutlet var btnUpdate: UIButton?
    @IBOutlet var procDownload: UIProgressView?
    @IBOutlet var tvLog: UITextView?

    var _update_file_size: Int64?
    
    var inited = false
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (!inited) {
            inited = true
            for temp in self.view.subviews {
                if (temp is UILabel) || (temp is UITextView) || (temp is UIButton) || (temp is UIProgressView) {
                    UIUtils.scaleComponent(view: temp)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIUtils.setStatusBar(light: true)
        UIUtils.setNavBar(nav: self.navigationController!.navigationBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inited = false
        self.title = RIGHT_MENU_UPDATE
        self.btnUpdate!.setTitle(STR_DOWNLOAD_NA, for: [])
        self.procDownload!.isHidden = true
        self.btnUpdate!.isHidden = false
        
        let build = (ApplicationUtils.getAppBuild() as NSString).integerValue
        let lastCard = DatabaseUtils.queryCardCount()
        let dbver = DatabaseUtils.getDatabaseVersion()
        let param = String(format: PARAM_UPDATE, build, lastCard, dbver)
        let hu = HttpUtils()
        hu.tag = 1
        hu.delegate = self
        hu.get(url: "\(URL_UPDATE)?\(param)")
        self.lblCurrentCount!.text = String(format: STR_CARD_COUNT, lastCard)
        self.lblNewCount!.text = String(format: STR_CARD_COUNT, 0)
        // load update log
        let huLog = HttpUtils()
        huLog.tag = 3
        huLog.delegate = self
        huLog.get(url: URL_UPDATE_LOG)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedData data: NSData?) {
        switch (httpUtils.tag!) {
        case 1:
            self.extractUpdateInfo(json: data!)
        case 2:
            self.uncompressData(data: data!)
        case 3:
            self.showUpdateLog(data: data!)
        default:
            break
        }
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedFileSize fileSize: Int64) {
        if (httpUtils.tag == 2) {
            _update_file_size = fileSize
            self.procDownload!.isHidden = false
        }
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedProgress progress: Int) {
        if (httpUtils.tag == 2) {
            let percent: Float = Float(progress) / Float(_update_file_size!)
            self.procDownload!.progress = percent
        }
    }
    
    func httpUtils(httpUtils: HttpUtils, receivedError err: String) {
        
    }
    
    @IBAction func updateClicked(sender: AnyObject) {
        self.btnUpdate!.isEnabled = false
        self.procDownload!.progress = 0
        self.procDownload!.isHidden = false
        let hu = HttpUtils()
        hu.tag = 2
        hu.delegate = self
        hu.get(url: URL_FILE_DATABASE)
    }
    
    func extractUpdateInfo(json: NSData) {
        let info = (try! JSONSerialization.jsonObject(with: json as Data, options:JSONSerialization.ReadingOptions.mutableLeaves)) as! NSDictionary
        let newcard = (info.object(forKey: "newcard") as! NSString).integerValue
        if (newcard != 0) {
            self.btnUpdate!.setTitle(STR_DOWNLOAD_UPDATE, for:[])
            self.btnUpdate!.isEnabled = true
            self.lblNewCount!.text = String(format: STR_CARD_COUNT, newcard)
        } else {
            self.btnUpdate!.setTitle(STR_DOWNLOAD_NA, for:[])
            self.btnUpdate!.isEnabled = false
        }
    }
    
    func uncompressData(data: NSData) {
        FileUtils.writeFile(fileName: ZIP_NAME, savePath:"", fileData:data)
        let zu = ZipUtils()
        let archivePath = "\(FileUtils.getDocumentPath())/\(ZIP_NAME)"
        zu.archiveFile = archivePath
        zu.extractPath = FileUtils.getDocumentPath()
        zu.delegate = self
        zu.unzip()
    }
    
    func showUpdateLog(data: NSData) {
        let str = NSString(data: data as Data, encoding:String.Encoding.utf8.rawValue)
        self.tvLog!.text = str! as String
    }
    
    func ziputils(ziputils: ZipUtils, unzipCompleted succ: Bool) {
        let _ = DatabaseUtils.openDatabase()
        self.btnUpdate!.setTitle(STR_DOWNLOAD_NA, for:[])
        self.procDownload!.isHidden = true
        self.btnUpdate!.isEnabled = false
        let lastCard = DatabaseUtils.queryLastCardId()
        self.lblCurrentCount!.text = String(format: STR_CARD_COUNT, lastCard)
        self.lblNewCount!.text = String(format: STR_CARD_COUNT, 0)
    }

    func zipWillUnzip() -> Bool {
        DatabaseUtils.closeDatabase()
        return true
    }

}
