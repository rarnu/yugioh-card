import UIKit

class FeedbackViewController: UIViewController {

    
    @IBOutlet var txtFeedback: UITextView?
    @IBOutlet var btnSend: UIBarButtonItem?
    
    var inited = false
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (!inited) {
            inited = true
            for temp in self.view.subviews {
                if (temp is UITextView) {
                    UIUtils.scaleComponent(temp)
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        UIUtils.setStatusBar(true)
        UIUtils.setNavBar(self.navigationController!.navigationBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inited = false
        self.title = RIGHT_MENU_FEEDBACK
        self.txtFeedback!.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func sendClicked(sender: AnyObject) {
        self.view.endEditing(true)
        let _appver = ApplicationUtils.getAppVersion() as NSString
        let appver = _appver.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let _txt = self.txtFeedback!.text as NSString
        let txt = _txt.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let dev = UIDevice.currentDevice()
        let osver = dev.systemVersion
        let osname = dev.systemName
        let _osstr = "\(osname) (\(osver))" as NSString
        let osstr = _osstr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let _uuid = dev.identifierForVendor!.UUIDString;
        let uuid = (_uuid as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    
        let param = NSString(format: PARAM_FEEDBACK, uuid!, "", txt!, appver!, osstr!)
        let hu = HttpUtils()
        hu.get("\(URL_FEEDBACK)?\(param)")
        self.navigationController!.popViewControllerAnimated(true)
    }

}
