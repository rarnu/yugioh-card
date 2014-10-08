import UIKit

var _instance: RootViewController?

class RootViewController: RESideMenu, RESideMenuDelegate {

    class func getInstance() -> RootViewController? {
        return _instance
    }
    
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
        
        var singleStory = UIStoryboard(name: "SingleStories", bundle: nil)
        var ccontent = self.storyboard!.instantiateViewControllerWithIdentifier("contentViewController") as UIViewController
        self.contentViewController = ccontent
        var cleftmenu = singleStory.instantiateViewControllerWithIdentifier("leftMenuViewController") as UIViewController
        self.leftMenuViewController = cleftmenu
        var crightmenu = singleStory.instantiateViewControllerWithIdentifier("rightMenuViewController") as UIViewController
        self.rightMenuViewController = crightmenu

        var background_name = ConfigUtils.loadBackgroundImage()
        if (background_name == nil || background_name == "") {
            background_name = "bg1"
        }
        self.backgroundImage = UIImage(named: background_name!)
        self.delegate = self;
        _instance = self;

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func sideMenu(sideMenu: RESideMenu, didHideMenuViewController menuViewController: UIViewController) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu, didShowMenuViewController menuViewController: UIViewController) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu, willHideMenuViewController menuViewController: UIViewController) {
        
    }
    func sideMenu(sideMenu: RESideMenu, willShowMenuViewController menuViewController: UIViewController) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu, didRecognizePanGesture recognizer: UIPanGestureRecognizer?) {
    
    }

}


