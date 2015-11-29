import UIKit

@objc
protocol DiceDelegate: NSObjectProtocol {
    optional func doneDice()
}

class DiceView: UIView {
    var imgDice: UIImageView?
    var delegate: DiceDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.makeUI()
    }
    
    func makeUI() {
        self.backgroundColor = UIColor.clearColor()
        self.imgDice = UIImageView(frame: CGRectMake(50, 0, self.frame.size.width-100, self.frame.size.height))
        self.imgDice!.contentMode = UIViewContentMode.ScaleAspectFit
        self.imgDice!.userInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: "closeClicked:")
        self.imgDice!.addGestureRecognizer(singleTap)
    
        let diceval = arc4random() % 6 + 1
        let imgName = "dice\(diceval)"
        self.imgDice!.image = UIImage(named: imgName)
    
        self.addSubview(self.imgDice!)
    }
    
    func closeClicked(sender: AnyObject) {
        self.delegate?.doneDice?()
    }
    

}
