import UIKit

class FeedbackViewController: UIViewController {

    
    @IBOutlet var txtFeedback: UITextView?
    @IBOutlet var btnSend: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = RIGHT_MENU_FEEDBACK
        self.txtFeedback!.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func sendClicked(sender: AnyObject) {
        self.view.endEditing(true)
        var _appver = ApplicationUtils.getAppVersion() as NSString
        var appver = _appver.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var _txt = self.txtFeedback!.text as NSString
        var txt = _txt.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var dev = UIDevice.currentDevice()
        var osver = dev.systemVersion
        var osname = dev.systemName
        var _osstr = "\(osname) (\(osver))" as NSString
        var osstr = _osstr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var _uuid = dev.identifierForVendor.UUIDString;
        var uuid = _uuid.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    
        var param = NSString(format: PARAM_FEEDBACK, uuid!, "", txt!, appver!, osstr!)
        var hu = HttpUtils()
        hu.get("\(URL_FEEDBACK)?\(param)")
        self.navigationController!.popViewControllerAnimated(true)
    }


}
