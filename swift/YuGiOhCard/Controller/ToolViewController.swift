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
    
    var inited = false
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (!inited) {
            inited = true
            for temp in self.view.subviews {
                if (temp is UILabel) || (temp is UITextField) || (temp is UIButton) {
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
        let bkImg = UIImage(named: "navbg")
        btnDice!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btnCoin!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn1Add!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn1Minus!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn1Set!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn1Half!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn1Double!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn1Balance!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn1Equal!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn2Add!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn2Minus!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn2Set!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn2Half!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn2Double!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn2Balance!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        btn2Equal!.setBackgroundImage(bkImg!, for: UIControlState.highlighted)
        
        self.txt1Life!.layer.borderWidth = 0.5
        self.txt1Life!.layer.borderColor = UIColor.lightGray().cgColor
        self.txt2Life!.layer.borderWidth = 0.5
        self.txt2Life!.layer.borderColor = UIColor.lightGray().cgColor
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
        let rect = UIScreen.main().applicationFrame
        let rw = rect.size.width * 0.8
        let left = (rect.size.width - rw) / 2
        dice = DiceView(frame: CGRect(x: left, y: rect.size.height, width: rw, height: 266))
        dice!.delegate = self
    
        self.view.addSubview(dice!)
        self.btnDice!.isEnabled = false
        self.btnCoin!.isEnabled = false
        
        UIView.animate(withDuration: 0.5, animations: { () in
            var rectSelectDate = self.dice!.frame
            rectSelectDate.origin.y = (rect.size.height - self.dice!.frame.size.height) / 2
            self.dice!.frame = rectSelectDate
            }, completion: { (_) in
        })
    }
    
    @IBAction func btnCoinClick(sender: AnyObject) {
        let rect = UIScreen.main().applicationFrame
        let rw = rect.size.width * 0.8
        let left = (rect.size.width - rw) / 2
        coin = CoinView(frame: CGRect(x: left, y: rect.size.height, width: rw, height: 266))
        coin!.delegate = self
    
        self.view.addSubview(coin!)
        self.btnDice!.isEnabled = false
        self.btnCoin!.isEnabled = false

        UIView.animate(withDuration: 0.5, animations: { () in
            var rectSelectDate = self.coin!.frame
            rectSelectDate.origin.y = (rect.size.height - self.coin!.frame.size.height) / 2
            self.coin!.frame = rectSelectDate
            }, completion: { (_) in
        })
    }
    
    @IBAction func resetClick(sender: AnyObject) {
        player1Life = 8000
        player2Life = 8000
        self.showLife()
    }
    
    @IBAction func btn1AddClick(sender: AnyObject) {
        let lifeDelta = (self.txt1Life!.text! as NSString).integerValue
        player1Life += Int(lifeDelta)
        self.showLife()
    }
    
    @IBAction func btn1MinusClick(sender: AnyObject) {
        let lifeDelta = (self.txt1Life!.text! as NSString).integerValue
        player1Life -= Int(lifeDelta)
        if (player1Life < 0) {
            player1Life = 0
        }
        self.showLife()
    }
    
    @IBAction func btn1SetClick(sender: AnyObject) {
        let lifeDelta = (self.txt1Life!.text! as NSString).integerValue
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
        let life = (player1Life + player2Life) / 2
        player1Life = Int(life)
        player2Life = Int(life)
        self.showLife()
    }
    
    @IBAction func btn1EqualClick(sender: AnyObject) {
        player1Life = player2Life
        self.showLife()
    }
    
    @IBAction func btn2AddClick(sender: AnyObject) {
        let lifeDelta = (self.txt2Life!.text! as NSString).integerValue
        player2Life += Int(lifeDelta)
        self.showLife()
    }
    
    @IBAction func btn2MinusClick(sender: AnyObject) {
        let lifeDelta = (self.txt2Life!.text! as NSString).integerValue
        player2Life -= Int(lifeDelta)
        self.showLife()
    }
    
    @IBAction func btn2SetClick(sender: AnyObject) {
        let lifeDelta = (self.txt2Life!.text! as NSString).integerValue
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
        let life = (player1Life + player2Life) / 2
        player1Life = Int(life)
        player2Life = Int(life)
        self.showLife()
    }
    
    @IBAction func btn2EqualClick(sender: AnyObject) {
        player2Life = player1Life
        self.showLife()
    }

    func doneDice() {
        let rect = UIScreen.main().applicationFrame
        UIView.animate(withDuration: 0.5, animations: { () in
            var rectSelectDate = self.dice!.frame
            rectSelectDate.origin.y = rect.size.height
            self.dice!.frame = rectSelectDate
            }, completion: { (_) in
                self.dice!.removeFromSuperview()
                self.btnCoin!.isEnabled = true
                self.btnDice!.isEnabled = true
        })
    }
    
    func doneCoin() {
        let rect = UIScreen.main().applicationFrame
        UIView.animate(withDuration: 0.5, animations: { () in
            var rectSelectDate = self.coin!.frame
            rectSelectDate.origin.y = rect.size.height
            self.coin!.frame = rectSelectDate
            }, completion: { (_) in
                self.coin!.removeFromSuperview()
                self.btnCoin!.isEnabled = true
                self.btnDice!.isEnabled = true
        })
    }

}
