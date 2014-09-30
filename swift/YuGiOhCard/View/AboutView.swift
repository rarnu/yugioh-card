import UIKit

@objc
protocol AboutViewDelegate: NSObjectProtocol {
    optional func aboutview(view: AboutView, tapped dismiss: Bool)
}

class AboutView: UIView {
    
    @IBOutlet var lblVersion: UILabel?
    @IBOutlet var lblPublic: UILabel?
    
    var delegate: AboutViewDelegate?
    
    class func initWithNib() -> AboutView? {
        var nib = UINib(nibName: "AboutView", bundle: NSBundle.mainBundle())
        var view = nib.instantiateWithOwner(nil, options: nil)[0] as? AboutView
        view!.makeUI()
        return view
    }
    
    func makeUI() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        var size = ApplicationUtils.getApplicationSize()
        var cx: CGFloat = size.width / 2
        var cy: CGFloat = size.height / 2
        self.center = CGPointMake(cx, cy)
        self.userInteractionEnabled = true
            
        var tap =  UITapGestureRecognizer(target: self, action: "tapped:")
        self.addGestureRecognizer(tap)
        self.fillData()
    }
    
    func fillData() {
        self.lblVersion!.text = "ver \(ApplicationUtils.getAppVersion()) (\(ApplicationUtils.getAppBuild()))"
        self.lblPublic!.text =  NSString(format: STR_PUBLIC_DATE, ApplicationUtils.getPublicDate()) as String
    }
    
    func tapped(sender: AnyObject) {
        self.delegate?.aboutview?(self, tapped: true)
    }

}
