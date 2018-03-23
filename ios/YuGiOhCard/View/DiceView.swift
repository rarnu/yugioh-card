import UIKit

@objc protocol DiceDelegate: NSObjectProtocol {
    @objc optional func doneDice()
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
        self.backgroundColor = UIColor.clear
        self.imgDice = UIImageView(frame: CGRect(x: 50, y: 0, width: self.frame.size.width - 100, height: self.frame.size.height))
        self.imgDice!.contentMode = UIViewContentMode.scaleAspectFit
        self.imgDice!.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(closeClicked(sender:)))
        self.imgDice!.addGestureRecognizer(singleTap)
        let diceval = arc4random() % 6 + 1
        let imgName = "dice\(diceval)"
        self.imgDice!.image = UIImage(named: imgName)
    
        self.addSubview(self.imgDice!)
    }
    
    @objc func closeClicked(sender: AnyObject) {
        self.delegate?.doneDice?()
    }
    

}
