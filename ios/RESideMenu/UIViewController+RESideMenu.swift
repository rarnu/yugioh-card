import UIKit

extension UIViewController {
    
    var sideMenuViewController: RESideMenu? {
        get {
            var iter: UIViewController? = self.parent
            while (iter != nil) {
                if (iter is RESideMenu) {
                    return iter as? RESideMenu
                } else if (iter!.parent != nil && iter!.parent != iter) {
                    iter = iter!.parent
                } else {
                    iter = nil;
                }
            }
            return nil;
        }
    }
    
    @IBAction func presentLeftMenuViewController(sender: AnyObject) {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    @IBAction func presentRightMenuViewController(sender: AnyObject) {
        self.sideMenuViewController!.presentRightMenuViewController()
    }
}
