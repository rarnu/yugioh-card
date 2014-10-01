import UIKit

var player1Life: Int = 8000
var player2Life: Int = 8000

class ToolViewController: UIViewController, CoinDelegate, DiceDelegate {
    
    // global
    @IBOutlet var resetButton: UIBarButtonItem?
    @IBOutlet var lbl1Life: UILabel?
    @IBOutlet var lbl2Life: UILabel?
    @IBOutlet var btnDice: UIButton?
    @IBOutlet var btnCoin: UIButton?
    
    // player1
    @IBOutlet var txt1Life: UITextField?
    @IBOutlet var btn1Add: UIButton?
    @IBOutlet var btn1Minus: UIButton?
    @IBOutlet var btn1Set: UIButton?
    @IBOutlet var btn1Half: UIButton?
    @IBOutlet var btn1Double: UIButton?
    @IBOutlet var btn1Balance: UIButton?
    @IBOutlet var btn1Equal: UIButton?
    
    // player2
    @IBOutlet var txt2Life: UITextField?
    @IBOutlet var btn2Add: UIButton?
    @IBOutlet var btn2Minus: UIButton?
    @IBOutlet var btn2Set: UIButton?
    @IBOutlet var btn2Half: UIButton?
    @IBOutlet var btn2Double: UIButton?
    @IBOutlet var btn2Balance: UIButton?
    @IBOutlet var btn2Equal: UIButton?
    
    var dice: DiceView?
    var coin: CoinView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt1Life!.layer.borderWidth = 0.5
        self.txt1Life!.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.txt2Life!.layer.borderWidth = 0.5
        self.txt2Life!.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.showLife()

    }
    
    func showLife() {
        self.lbl1Life!.text = "\(player1Life)"
        self.lbl2Life!.text = "\(player2Life)"
        self.txt1Life!.text = ""
        self.txt2Life!.text = ""
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnDiceClick(sender: AnyObject) {
        var rect = UIScreen.mainScreen().applicationFrame
        var rw = rect.size.width * 0.8
        var left = (rect.size.width - rw) / 2
        dice = DiceView(frame: CGRectMake(left, rect.size.height, rw, 266))
        dice!.delegate = self
    
        self.view.addSubview(dice!)
        self.btnDice!.enabled = false
        self.btnCoin!.enabled = false
        
        func _anim_doing() {
            var rectSelectDate = dice!.frame
            rectSelectDate.origin.y = (rect.size.height - dice!.frame.size.height) / 2
            dice!.frame = rectSelectDate
        }
        
        func _anim_complete(var finished: Bool) {
            finished = true
        }
        
        UIView.animateWithDuration(0.5, animations: _anim_doing, completion: _anim_complete)
    }
    
    @IBAction func btnCoinClick(sender: AnyObject) {
        var rect = UIScreen.mainScreen().applicationFrame
        var rw = rect.size.width * 0.8
        var left = (rect.size.width - rw) / 2
        coin = CoinView(frame: CGRectMake(left, rect.size.height, rw, 266))
        coin!.delegate = self
    
        self.view.addSubview(coin!)
        self.btnDice!.enabled = false
        self.btnCoin!.enabled = false

        func _anim_doing() {
            var rectSelectDate = coin!.frame
            rectSelectDate.origin.y = (rect.size.height - coin!.frame.size.height) / 2
            coin!.frame = rectSelectDate
        }
        func _anim_complete(var finished: Bool) {
            finished = true
        }
        UIView.animateWithDuration(0.5, animations: _anim_doing, completion: _anim_complete)
    }
    
    @IBAction func resetClick(sender: AnyObject) {
        player1Life = 8000
        player2Life = 8000
        self.showLife()
    }
    
    @IBAction func btn1AddClick(sender: AnyObject) {
        var lifeDelta = (self.txt1Life!.text as NSString).integerValue
        player1Life += Int(lifeDelta)
        self.showLife()
    }
    
    @IBAction func btn1MinusClick(sender: AnyObject) {
        var lifeDelta = (self.txt1Life!.text as NSString).integerValue
        player1Life -= Int(lifeDelta)
        if (player1Life < 0) {
            player1Life = 0
        }
        self.showLife()
    }
    
    @IBAction func btn1SetClick(sender: AnyObject) {
        var lifeDelta = (self.txt1Life!.text as NSString).integerValue
        player1Life = Int(lifeDelta)
        self.showLife()
    
    }
    @IBAction func btn1HalfClick(sender: AnyObject) {
        player1Life /= 2
        self.showLife()
    }
    
    @IBAction func btn1DoubleClick(sender: AnyObject) {
        player1Life *= 2
        self.showLife()
    }
    
    @IBAction func btn1BalanceClick(sender: AnyObject) {
        var life = (player1Life + player2Life) / 2
        player1Life = Int(life)
        player2Life = Int(life)
        self.showLife()
    }
    
    @IBAction func btn1EqualClick(sender: AnyObject) {
        player1Life = player2Life
        self.showLife()
    }
    
    @IBAction func btn2AddClick(sender: AnyObject) {
        var lifeDelta = (self.txt2Life!.text as NSString).integerValue
        player2Life += Int(lifeDelta)
        self.showLife()
    }
    
    @IBAction func btn2MinusClick(sender: AnyObject) {
        var lifeDelta = (self.txt2Life!.text as NSString).integerValue
        player2Life -= Int(lifeDelta)
        self.showLife()
    }
    
    @IBAction func btn2SetClick(sender: AnyObject) {
        var lifeDelta = (self.txt2Life!.text as NSString).integerValue
        player2Life = Int(lifeDelta)
        self.showLife()
    }
    
    @IBAction func btn2HalfClick(sender: AnyObject) {
        player2Life /= 2
        self.showLife()
    }
    
    @IBAction func btn2DoubleClick(sender: AnyObject) {
        player2Life *= 2
        self.showLife()
    }
    
    @IBAction func btn2BalanceClick(sender: AnyObject) {
        var life = (player1Life + player2Life) / 2
        player1Life = Int(life)
        player2Life = Int(life)
        self.showLife()
    }
    
    @IBAction func btn2EqualClick(sender: AnyObject) {
        player2Life = player1Life
        self.showLife()
    }

    func doneDice() {
        
        var rect = UIScreen.mainScreen().applicationFrame
        func _anim_doing() {
            var rectSelectDate = dice!.frame
            rectSelectDate.origin.y = rect.size.height
            dice!.frame = rectSelectDate
        }
        func _anim_complete(var finished: Bool) {
            dice!.removeFromSuperview()
            self.btnCoin!.enabled = true
            self.btnDice!.enabled = true
            finished = true
        }
        
        UIView.animateWithDuration(0.5, animations: _anim_doing, completion: _anim_complete)
    }
    
    func doneCoin() {
        var rect = UIScreen.mainScreen().applicationFrame
        func _anim_doing() {
            var rectSelectDate = coin!.frame
            rectSelectDate.origin.y = rect.size.height
            coin!.frame = rectSelectDate
        }
        func _anim_complete(var finished: Bool) {
            coin!.removeFromSuperview()
            self.btnCoin!.enabled = true
            self.btnDice!.enabled = true
            finished = true
        }
        UIView.animateWithDuration(0.5, animations: _anim_doing, completion: _anim_complete)
    }

}
