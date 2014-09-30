import UIKit

class PushUtils: NSObject {

    class func pushCard(item: CardItem, navController: UINavigationController) {
        var cardStory = UIStoryboard(name: "CardStory", bundle: nil)
        var cc = cardStory.instantiateViewControllerWithIdentifier("cardViewController") as CardViewController
        cc.cardId = item.card_id
        cc.cardName = item.name
        navController.pushViewController(cc, animated: true)
        
    }

}
