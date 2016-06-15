import UIKit

class CardAdjustViewController: UIViewController {

    @IBOutlet var txtAdjust: UITextView?
    var card: CardItem?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inited = false
        self.card = (self.tabBarController! as! CardViewController).card
        let str = "\(self.card!.adjust)\n"
        self.txtAdjust!.text = str
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
