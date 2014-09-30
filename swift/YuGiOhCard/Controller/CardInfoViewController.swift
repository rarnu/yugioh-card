import UIKit

class CardInfoViewController: UIViewController {

    @IBOutlet var txtInfo: UITextView?
    var card: CardItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.card = (self.tabBarController! as CardViewController).card
        var str = NSString(format: CARD_BASE_INFO, self.card!.name, self.card!.japName, self.card!.enName, self.card!.sCardType)
        
        if ((self.card!.sCardType as NSString).rangeOfString(_monster).location != NSNotFound) {
            str = str.stringByAppendingString(LINE)
            var level = "\(self.card!.level)"
            if ((self.card!.sCardType as NSString).rangeOfString(CARD_XYZ).location != NSNotFound) {
                level += CARD_RANK
            }
            str = str.stringByAppendingFormat(CARD_MONSTER_INFO, self.card!.element, level, self.card!.tribe, self.card!.atk, self.card!.def)
            if ((self.card!.cardDType as NSString).rangeOfString(MONSTER_PENDULUM).location != NSNotFound) {
                str = str.stringByAppendingFormat(MONSTER_PENDULUM_SCALE, self.card!.pendulumL, self.card!.pendulumR)
            }
        }
        str = str.stringByAppendingString(LINE)
        str = str.stringByAppendingFormat(CARD_EXTRA_INFO, self.card!.ban, self.card!.package, self.card!.cardCamp, self.card!.cheatcode, self.card!.infrequence)
        
        str = str.stringByAppendingString(LINE)
        str = str.stringByAppendingFormat(CARD_EFFECT_INFO, self.card!.effect)
        
        self.txtInfo!.text = str as String

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}