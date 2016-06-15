import UIKit

class RootViewController: RESideMenu, RESideMenuDelegate {
    
    override func awakeFromNib() {
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.lightContent
        self.contentViewShadowColor = UIColor.black()
        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        self.contentViewScaleValue = 0.9
        self.scaleContentView = false
        self.scaleMenuView = false
        self.scaleBackgroundImageView = false
        
        let singleStory = UIStoryboard(name: "SingleStories", bundle: nil)
        let ccontent = self.storyboard!.instantiateViewController(withIdentifier: "contentViewController") 
        self.contentViewController = ccontent
        let cleftmenu = singleStory.instantiateViewController(withIdentifier: "leftMenuViewController") 
        self.leftMenuViewController = cleftmenu
        let crightmenu = singleStory.instantiateViewController(withIdentifier: "rightMenuViewController") 
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
        UIApplication.shared().setStatusBarHidden(false, with: UIStatusBarAnimation.none)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default().addObserver(self, selector: #selector(receivedNotification(notification:)), name: "Notification_ChangeBackground", object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default().removeObserver(self, name: "Notification_ChangeBackground" as NSNotification.Name, object: nil)
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


