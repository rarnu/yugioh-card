import UIKit

@objc
protocol CoinDelegate: NSObjectProtocol {
    optional func doneCoin()
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
        self.backgroundColor = UIColor.clearColor()
        self.imgCoin = UIImageView(frame: CGRectMake(50, 0, self.frame.size.width-100, self.frame.size.height))
        self.imgCoin!.contentMode = UIViewContentMode.ScaleAspectFit
        self.imgCoin!.userInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: "closeClicked:")
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
