import UIKit

class CardViewController: UITabBarController {

    var cardId: Int?
    var cardName: String?
    var card: CardItem?
    
    var likeButton: UIBarButtonItem?
    var unlikeButton: UIBarButtonItem?
    
    override func viewWillAppear(animated: Bool) {
        UIUtils.setStatusBar(true)
        UIUtils.setNavBar(self.navigationController!.navigationBar)
        UIUtils.setTabBar(self.tabBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.cardName!
        self.card = DatabaseUtils.queryOneCard(self.cardId!)
        likeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(CardViewController.likeClicked(_:)))
        unlikeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: #selector(CardViewController.unlikeClicked(_:)))
        let isFav = DatabaseUtils.favExists(self.cardId!)
        self.navigationItem.rightBarButtonItem = isFav ? unlikeButton : likeButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func likeClicked(sender: AnyObject) {
        DatabaseUtils.favAdd(self.cardId!)
        self.navigationItem.rightBarButtonItem = unlikeButton!
    }
    
    func unlikeClicked(sender: AnyObject) {
        DatabaseUtils.favRemove(self.cardId!)
        self.navigationItem.rightBarButtonItem = likeButton!
    }
    


}
