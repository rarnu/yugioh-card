import UIKit

class UIBackgroundImageCell : UICollectionViewCell {
    var imgName: NSString?
    @IBOutlet var img: UIImageView?
    @IBOutlet var selectMark: UIImageView?
}


class SettingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate {

    @IBOutlet var btnSpace: UIButton?
    @IBOutlet var colImg: UICollectionView?
    @IBOutlet var btnSource: UIButton?
    
    var _backgrounds: NSMutableArray?
    var _grid_size: CGSize?
    var _current_background: String?
    var _document: String?
    var fmgr: FileManager?
    
    var inited = false
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (!inited) {
            inited = true
            for temp in self.view.subviews {
                if (temp is UILabel) || (temp is UIButton) || (temp is UICollectionView) {
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
        self.title = RIGHT_MENU_SETTING
        _grid_size = self.generateImageSize()
        _current_background = ConfigUtils.loadBackgroundImage()
        if (_current_background == nil || _current_background! == "") {
            _current_background = "bg1"
        }
        
        _backgrounds = NSMutableArray()
        for i in 1 ... 9 {
            _backgrounds!.add("bg\(i)")
        }
        _document = FileUtils.getDocumentPath()
        fmgr = FileManager.default()
        let sizeStr = NSString(format: "%.2f M", FileUtils.folderSizeAtPath(folderPath: _document!))
        self.btnSpace!.setTitle(sizeStr as String, for: [])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cleanClicked(sender: AnyObject) {
        let alert = UIAlertView(title: STR_CONFIRM, message: STR_CONFIRM_CLEAR_DOCUMENT, delegate: self, cancelButtonTitle: COMMON_CANCEL, otherButtonTitles: COMMON_OK)
        alert.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        switch (buttonIndex) {
        case 1:
            self.removeDocumentFiles()
            self.btnSpace!.setTitle(NSString(format: "%.2f M", FileUtils.folderSizeAtPath(folderPath: _document!)) as String,for:[])
        default:
            break
        }
    }
    
    func removeDocumentFiles() {
        let imgPath = "\(_document!)/image"
        do {
            try fmgr!.removeItem(atPath: imgPath)
        } catch _ {
        }
        if (!fmgr!.fileExists(atPath: imgPath)) {
            do {
                try fmgr!.createDirectory(atPath: imgPath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _backgrounds!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for:indexPath as IndexPath) as! UIBackgroundImageCell
        cell.imgName = _backgrounds![indexPath.row] as! String
        cell.img!.image = UIImage(named: cell.imgName as! String)
        cell.selectMark!.isHidden = _current_background! != cell.imgName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath as IndexPath, animated:true)
        _current_background = _backgrounds![indexPath.row] as? String
        ConfigUtils.saveBackgroundImage(imgName: _current_background!)
        let nc = NotificationCenter.default()
        nc.post(name: "Notification_ChangeBackground" as NSNotification.Name, object: _current_background!)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return _grid_size!
    }
    
    func generateImageSize() -> CGSize {
        let (screenWidth, _) = UIUtils.getScreenSize()
        var scale: CGFloat = 1.0
        if (screenWidth > 320) {
            scale = screenWidth / 320
        }
        let w = (screenWidth - ((13 * 4) * scale)) / 3
        let h = 166 * w / 89
        return CGSize(width: w, height: h)
    }

    @IBAction func sourceClicked(sender: AnyObject) {
        UIApplication.shared().openURL(NSURL(string: URL_GITHUB)! as URL)
    }

}
