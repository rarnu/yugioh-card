import UIKit

class PushUtils: NSObject {

    class func pushCard(item: CardItem, navController: UINavigationController) {
        let cardStory = UIStoryboard(name: "CardStory", bundle: nil)
        let cc = cardStory.instantiateViewController(withIdentifier: "cardViewController") as! CardViewController
        cc.cardId = item._id
        cc.cardName = item.name
        navController.pushViewController(cc, animated: true)
        
    }

}
