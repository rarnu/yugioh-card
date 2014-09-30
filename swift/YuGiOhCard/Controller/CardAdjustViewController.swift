import UIKit

class CardAdjustViewController: UIViewController {

    @IBOutlet var txtAdjust: UITextView?
    var card: CardItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.card = (self.tabBarController! as CardViewController).card
        var str = "\(self.card!.adjust)\n"
        self.txtAdjust!.text = str
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
