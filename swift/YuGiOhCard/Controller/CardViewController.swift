import UIKit

class CardViewController: UITabBarController {

    var cardId: Int?
    var cardName: String?
    var card: CardItem?
    
    var likeButton: UIBarButtonItem?
    var unlikeButton: UIBarButtonItem?
    
    override func viewWillAppear(_ animated: Bool) {
        UIUtils.setStatusBar(light: true)
        UIUtils.setNavBar(nav: self.navigationController!.navigationBar)
        UIUtils.setTabBar(tab: self.tabBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.cardName!
        self.card = DatabaseUtils.queryOneCard(cardId: self.cardId!)
        likeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(likeClicked(sender:)))
        unlikeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(unlikeClicked(sender:)))
        let isFav = DatabaseUtils.favExists(cardId: self.cardId!)
        self.navigationItem.rightBarButtonItem = isFav ? unlikeButton : likeButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func likeClicked(sender: AnyObject) {
        DatabaseUtils.favAdd(cardId: self.cardId!)
        self.navigationItem.rightBarButtonItem = unlikeButton!
    }
    
    func unlikeClicked(sender: AnyObject) {
        DatabaseUtils.favRemove(cardId: self.cardId!)
        self.navigationItem.rightBarButtonItem = likeButton!
    }
    


}
