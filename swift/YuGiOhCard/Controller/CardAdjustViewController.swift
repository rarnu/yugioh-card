import UIKit

class CardAdjustViewController: UIViewController {

    @IBOutlet var txtAdjust: UITextView?
    var card: CardItem?
    
    var inited = false
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (!inited) {
            inited = true
            var v: UIView?
            for temp in self.view.subviews {
                v = temp as? UIView
                if (v is UITextView) {
                    UIUtils.scaleComponent(v!)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inited = false
        self.card = (self.tabBarController! as! CardViewController).card
        var str = "\(self.card!.adjust)\n"
        self.txtAdjust!.text = str
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
