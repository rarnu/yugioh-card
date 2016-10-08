import UIKit

@objc protocol AboutViewDelegate: NSObjectProtocol {
    @objc optional func aboutview(view: AboutView, tapped dismiss: Bool)
}

class AboutView: UIView {
    
    @IBOutlet var lblVersion: UILabel?
    @IBOutlet var lblPublic: UILabel?
    
    var delegate: AboutViewDelegate?
    
    class func initWithNib() -> AboutView? {
        let nib = UINib(nibName: "AboutView", bundle: Bundle.main)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as? AboutView
        view!.makeUI()
        return view
    }
    
    func makeUI() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        let size = ApplicationUtils.getApplicationSize()
        let cx: CGFloat = size.width / 2
        let cy: CGFloat = size.height / 2
        self.center = CGPoint(x: cx, y: cy)
        self.isUserInteractionEnabled = true
            
        let tap =  UITapGestureRecognizer(target: self, action: #selector(tapped(sender:)))
        self.addGestureRecognizer(tap)
        self.fillData()
    }
    
    func fillData() {
        self.lblVersion!.text = "ver \(ApplicationUtils.getAppVersion()) (\(ApplicationUtils.getAppBuild()))"
        self.lblPublic!.text =  String(format: STR_PUBLIC_DATE, ApplicationUtils.getPublicDate())
    }
    
    func tapped(sender: AnyObject) {
        self.delegate?.aboutview?(view: self, tapped: true)
    }

}
