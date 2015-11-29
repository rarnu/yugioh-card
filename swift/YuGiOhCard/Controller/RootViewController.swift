import UIKit

class RootViewController: RESideMenu, RESideMenuDelegate {
    
    override func awakeFromNib() {
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.LightContent
        self.contentViewShadowColor = UIColor.blackColor()
        self.contentViewShadowOffset = CGSizeMake(0, 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        self.contentViewScaleValue = 0.9
        self.scaleContentView = false
        self.scaleMenuView = false
        self.scaleBackgroundImageView = false
        
        let singleStory = UIStoryboard(name: "SingleStories", bundle: nil)
        let ccontent = self.storyboard!.instantiateViewControllerWithIdentifier("contentViewController") 
        self.contentViewController = ccontent
        let cleftmenu = singleStory.instantiateViewControllerWithIdentifier("leftMenuViewController") 
        self.leftMenuViewController = cleftmenu
        let crightmenu = singleStory.instantiateViewControllerWithIdentifier("rightMenuViewController") 
        self.rightMenuViewController = crightmenu

        var background_name = ConfigUtils.loadBackgroundImage()
        if (background_name == nil || background_name == "") {
            background_name = "bg1"
        }
        self.backgroundImage = UIImage(named: background_name!)
        self.delegate = self
        
        
    }
    
    func receivedNotification(notification: NSNotification) {
        let backImg = notification.object! as! String
        self.backgroundImage = UIImage(named: backImg)
    }
    
//    func receivedNotification(imgPath: String) {
//        self.backgroundImage = UIImage(named: imgPath)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: "Notification_ChangeBackground", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "Notification_ChangeBackground", object: nil)
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func sideMenu(sideMenu: RESideMenu, didHideMenuViewController menuViewController: UIViewController?) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu, didShowMenuViewController menuViewController: UIViewController?) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu, willHideMenuViewController menuViewController: UIViewController?) {
        
    }
    func sideMenu(sideMenu: RESideMenu, willShowMenuViewController menuViewController: UIViewController?) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu, didRecognizePanGesture recognizer: UIPanGestureRecognizer?) {
    
    }

}


