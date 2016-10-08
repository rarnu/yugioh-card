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
        self.title = RIGHT_MENU_FEEDBACK
        self.txtFeedback!.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func sendClicked(sender: AnyObject) {
        self.view.endEditing(true)
        let _appver = ApplicationUtils.getAppVersion() as NSString
        let appver = _appver.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        let _txt = self.txtFeedback!.text as NSString
        let txt = _txt.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        let dev = UIDevice.current
        let osver = dev.systemVersion
        let osname = dev.systemName
        let _osstr = "\(osname) (\(osver))" as NSString
        let osstr = _osstr.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        let _uuid = dev.identifierForVendor!.uuidString
        let uuid = (_uuid as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        let param = String(format: PARAM_FEEDBACK, uuid!, "", txt!, appver!, osstr!)
        let hu = HttpUtils()
        hu.get(url: "\(URL_FEEDBACK)?\(param)")
        self.navigationController!.popViewController(animated: true)
    }

}
