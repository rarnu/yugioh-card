import UIKit

@objc protocol CoinDelegate: NSObjectProtocol {
    @objc optional func doneCoin()
}

class CoinView: UIView {

    var imgCoin: UIImageView?
    var delegate: CoinDelegate?

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
        self.imgCoin = UIImageView(frame: CGRect(x: 50, y: 0, width: self.frame.size.width-100, height: self.frame.size.height))
        self.imgCoin!.contentMode = UIViewContentMode.scaleAspectFit
        self.imgCoin!.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(closeClicked(sender:)))
        self.imgCoin!.addGestureRecognizer(singleTap)

        let coinval = arc4random() % 2 + 1
        let imgName = "coin\(coinval)"
        self.imgCoin!.image = UIImage(named: imgName)
        self.addSubview(self.imgCoin!)
    }
    
    func closeClicked(sender: AnyObject) {
        self.delegate?.doneCoin?()
    }

}
