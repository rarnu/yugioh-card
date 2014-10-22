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
    var _current_background: NSString?
    var _document: NSString?
    var fmgr: NSFileManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = RIGHT_MENU_SETTING
        _grid_size = self.generateImageSize()
        _current_background = ConfigUtils.loadBackgroundImage()
        if (_current_background == nil || _current_background! == "") {
            _current_background = "bg1"
        }
        
        _backgrounds = NSMutableArray()
        for (var i=1; i <= 9; i++) {
            _backgrounds!.addObject("bg\(i)")
        }
        _document = FileUtils.getDocumentPath()
        fmgr = NSFileManager.defaultManager()
        var sizeStr = NSString(format: "%.2f M", FileUtils.folderSizeAtPath(_document!))
        self.btnSpace!.setTitle(sizeStr, forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func cleanClicked(sender: AnyObject) {
        var alert = UIAlertView(title: STR_CONFIRM, message: STR_CONFIRM_CLEAR_DOCUMENT, delegate: self, cancelButtonTitle: COMMON_CANCEL, otherButtonTitles: COMMON_OK)
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch (buttonIndex) {
        case 1:
            self.removeDocumentFiles()
            self.btnSpace!.setTitle(NSString(format: "%.2f M", FileUtils.folderSizeAtPath(_document!)),forState:UIControlState.Normal)
        default:
            break
        }
    }
    
    func removeDocumentFiles() {
        var imgPath = "\(_document!)/image"
        fmgr!.removeItemAtPath(imgPath, error:nil)
        if (!fmgr!.fileExistsAtPath(imgPath)) {
            fmgr!.createDirectoryAtPath(imgPath, withIntermediateDirectories:true, attributes:nil, error:nil)
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _backgrounds!.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath:indexPath) as UIBackgroundImageCell
        cell.imgName = _backgrounds![indexPath.row] as String
        cell.img!.image = UIImage(named: cell.imgName!)
        cell.selectMark!.hidden = _current_background! != cell.imgName
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated:true)
        _current_background = _backgrounds![indexPath.row] as String
        ConfigUtils.saveBackgroundImage(_current_background!)
        var nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("Notification_ChangeBackground", object: _current_background!)
//        var root = RootViewController.getInstance()
//        if (root != nil) {
//            root!.backgroundImage = UIImage(named: _current_background!)
//        }
        collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return _grid_size!
    }
    
    func generateImageSize() -> CGSize {
        return CGSizeMake(89, 166)
    }

    @IBAction func sourceClicked(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: URL_GITHUB)!)
    }

}
