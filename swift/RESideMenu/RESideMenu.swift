import UIKit

@objc protocol RESideMenuDelegate: NSObjectProtocol {
    @objc optional func sideMenu(sideMenu:RESideMenu, didRecognizePanGesture recognizer: UIPanGestureRecognizer?)
    @objc optional func sideMenu(sideMenu:RESideMenu, willShowMenuViewController menuViewController: UIViewController?)
    @objc optional func sideMenu(sideMenu:RESideMenu, didShowMenuViewController menuViewController: UIViewController?)
    @objc optional func sideMenu(sideMenu:RESideMenu, willHideMenuViewController menuViewController: UIViewController?)
    @objc optional func sideMenu(sideMenu:RESideMenu, didHideMenuViewController menuViewController: UIViewController?)
    
}

class RESideMenu: UIViewController, UIGestureRecognizerDelegate {

    var _contentViewController: UIViewController? = nil
    
    var contentViewController: UIViewController? {
        get {
            return self._contentViewController
        }
        set (controller) {
            if (self._contentViewController == nil) {
                self._contentViewController = controller
                return
            }
            self.__hideViewController(viewController: self._contentViewController)
            self._contentViewController = controller
            self.addChildViewController(self._contentViewController!)
            self._contentViewController!.view.frame = self.view.bounds
            self.contentViewContainer!.addSubview(self._contentViewController!.view)
            self._contentViewController!.didMove(toParentViewController: self)
            
            self.__updateContentViewShadow()
            
            if (self.visible!) {
                self.__addContentViewControllerMotionEffects()
            }

        }
    }
    
    var _leftMenuViewController: UIViewController?
    var leftMenuViewController: UIViewController? {
        get {
            return self._leftMenuViewController
        }
        set (controller) {
            if (self._leftMenuViewController == nil) {
                self._leftMenuViewController = controller
                return
            }
            self.__hideViewController(viewController: self._leftMenuViewController)
            self._leftMenuViewController = controller
            
            self.addChildViewController(self._leftMenuViewController!)
            self._leftMenuViewController!.view.frame = self.view.bounds
            self._leftMenuViewController!.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight];
            self.menuViewContainer!.addSubview(self._leftMenuViewController!.view)
            self._leftMenuViewController!.didMove(toParentViewController: self)
            
            self.__addMenuViewControllerMotionEffects()
            self.view.bringSubview(toFront: self.contentViewContainer!)
        }
    }
    
    var _rightMenuViewController: UIViewController?
    var rightMenuViewController: UIViewController? {
        get {
            return self._rightMenuViewController
        }
        set (controller) {
            if (self._rightMenuViewController == nil) {
                self._rightMenuViewController = controller
                return
            }
            self.__hideViewController(viewController: self._rightMenuViewController)
            self._rightMenuViewController = controller
            
            self.addChildViewController(self._rightMenuViewController!)
            self._rightMenuViewController!.view.frame = self.view.bounds
            self._rightMenuViewController!.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight];
            self.menuViewContainer!.addSubview(self._rightMenuViewController!.view)
            self._rightMenuViewController!.didMove(toParentViewController: self)
            
            self.__addMenuViewControllerMotionEffects()
            self.view.bringSubview(toFront: self.contentViewContainer!)

        }
    }
    var delegate: RESideMenuDelegate?
    var animationDuration: TimeInterval?
    
    var _backgroundImage: UIImage?
    var backgroundImage: UIImage? {
        get {
            return self._backgroundImage
        }
        set (bgImg) {
            self._backgroundImage = bgImg;
            if (self.backgroundImageView != nil) {
                self.backgroundImageView!.image = _backgroundImage!
            }
        }
    }
    var panGestureEnabled: Bool?
    var panFromEdge: Bool?
    var panMinimumOpenThreshold: Int?
    var interactivePopGestureRecognizerEnabled: Bool?
    var fadeMenuView: Bool?
    var scaleContentView: Bool?
    var scaleBackgroundImageView: Bool?
    var scaleMenuView: Bool?
    var contentViewShadowEnabled: Bool?
    var contentViewShadowColor: UIColor?
    var contentViewShadowOffset: CGSize?
    var contentViewShadowOpacity: CGFloat?
    var contentViewShadowRadius: CGFloat?
    var contentViewScaleValue: CGFloat?
    var contentViewInLandscapeOffsetCenterX: CGFloat?
    var contentViewInPortraitOffsetCenterX: CGFloat?
    var parallaxMenuMinimumRelativeValue: CGFloat?
    var parallaxMenuMaximumRelativeValue: CGFloat?
    var parallaxContentMinimumRelativeValue: CGFloat?
    var parallaxContentMaximumRelativeValue: CGFloat?
    var menuViewControllerTransformation: CGAffineTransform?
    var parallaxEnabled: Bool?
    var bouncesHorizontally: Bool?
    var menuPreferredStatusBarStyle: UIStatusBarStyle?
    var menuPrefersStatusBarHidden: Bool? = false

    var backgroundImageView: UIImageView?
    var visible: Bool? = false
    var leftMenuVisible: Bool? = false
    var rightMenuVisible: Bool? = false
    var originalPoint: CGPoint?
    var contentButton: UIButton?
    var menuViewContainer: UIView?
    var contentViewContainer: UIView?
    var didNotifyDelegate: Bool?
    
    convenience init() {
        self.init()
        self.__commonInit()
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.__commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.__commonInit()
    }
    
    func __commonInit() {
        self.menuViewContainer = UIView()
        self.contentViewContainer = UIView()
        self.animationDuration = 0.35
        self.interactivePopGestureRecognizerEnabled = true
        self.menuViewControllerTransformation = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.scaleContentView = true
        self.scaleBackgroundImageView = true
        self.scaleMenuView = true
        self.fadeMenuView = true
        self.parallaxEnabled = true
        self.parallaxMenuMinimumRelativeValue = -15
        self.parallaxMenuMaximumRelativeValue = 15
        self.parallaxContentMinimumRelativeValue = -25
        self.parallaxContentMaximumRelativeValue = 25
        self.bouncesHorizontally = true
        self.panGestureEnabled = true
        self.panFromEdge = true
        self.panMinimumOpenThreshold = 60
        self.contentViewShadowEnabled = false
        self.contentViewShadowColor = UIColor.black()
        self.contentViewShadowOffset = CGSize.zero
        self.contentViewShadowOpacity = 0.4
        self.contentViewShadowRadius = 8.0
        self.contentViewInLandscapeOffsetCenterX = 30.0
        self.contentViewInPortraitOffsetCenterX  = 30.0
        self.contentViewScaleValue = 0.9
    }

    // =================================
    // public methods
    // =================================
    
    convenience init(contentViewController:UIViewController, leftMenuViewController: UIViewController, rightMenuViewController: UIViewController) {
        self.init()
        self.contentViewController = contentViewController
        self.leftMenuViewController = leftMenuViewController
        self.rightMenuViewController = rightMenuViewController
    }
    
    func presentLeftMenuViewController() {
        self.__presentMenuViewContainerWithMenuViewController(menuViewController: self.leftMenuViewController)
        self.__showLeftMenuViewController()
    }
    
    func presentRightMenuViewController() {
        self.__presentMenuViewContainerWithMenuViewController(menuViewController: self.rightMenuViewController)
        self.__showRightMenuViewController()
    }
    
    func hideMenuViewController() {
        self.__hideMenuViewControllerAnimated(animated: true)
    }
    
    func setContentViewController(contentViewController:UIViewController, animated:Bool) {
        if (self.contentViewController == contentViewController) {
            return
        }
    
        if (!animated) {
            self.contentViewController = contentViewController
        } else {
            self.addChildViewController(contentViewController)
            contentViewController.view.alpha = 0;
            contentViewController.view.frame = self.contentViewContainer!.bounds
            self.contentViewContainer!.addSubview(contentViewController.view)
            func _anim_doing() {
                contentViewController.view.alpha = 1
            }
            func _anim_complete(finish: Bool) {
                self.__hideViewController(viewController: self.contentViewController)
                contentViewController.didMove(toParentViewController: self)
                self.contentViewController = contentViewController
                self.__statusBarNeedsAppearanceUpdate()
                self.__updateContentViewShadow()
                if (self.visible!) {
                    self.__addContentViewControllerMotionEffects()
                }

            }
            UIView.animate(withDuration: self.animationDuration!, animations: _anim_doing, completion: _anim_complete)
        }
    }
    
    // =================================
    // view lifecycle
    // =================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = self.backgroundImage
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.backgroundImageView = imageView
        let button = UIButton(frame: CGRect.null)
        button.addTarget(self, action:#selector(hideMenuViewController), for:UIControlEvents.touchUpInside)
        self.contentButton = button
        
        self.view.addSubview(self.backgroundImageView!)
        self.view.addSubview(self.menuViewContainer!)
        self.view.addSubview(self.contentViewContainer!)
        
        self.menuViewContainer!.frame = self.view.bounds
        self.menuViewContainer!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        if (self.leftMenuViewController != nil) {
            self.addChildViewController(self.leftMenuViewController!)
            self.leftMenuViewController!.view.frame = self.view.bounds
            self.leftMenuViewController!.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            self.menuViewContainer!.addSubview(self.leftMenuViewController!.view)
            self.leftMenuViewController!.didMove(toParentViewController: self)
        }
        
        if (self.rightMenuViewController != nil) {
            self.addChildViewController(self.rightMenuViewController!)
            self.rightMenuViewController!.view.frame = self.view.bounds
            self.rightMenuViewController!.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            self.menuViewContainer!.addSubview(self.rightMenuViewController!.view)
            self.rightMenuViewController!.didMove(toParentViewController: self)
        }
        
        self.contentViewContainer!.frame = self.view.bounds
        self.contentViewContainer!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        self.addChildViewController(self.contentViewController!)
        self.contentViewController!.view.frame = self.view.bounds
        self.contentViewContainer!.addSubview(self.contentViewController!.view)
        self.contentViewController!.didMove(toParentViewController: self)
        
        self.menuViewContainer!.alpha = !self.fadeMenuView! ? 1 : 0
        if (self.scaleBackgroundImageView != nil) {
            self.backgroundImageView!.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
        }
        self.__addMenuViewControllerMotionEffects()
        
        if (self.panGestureEnabled!) {
            self.view.isMultipleTouchEnabled = false
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(__panGestureRecognized(recognizer:)))
            panGestureRecognizer.delegate = self
            self.view.addGestureRecognizer(panGestureRecognizer)
        }
        
        self.__updateContentViewShadow()
    }
    
    // =================================
    // privte method
    // =================================
    
    func __presentMenuViewContainerWithMenuViewController(menuViewController: UIViewController?) {
        self.menuViewContainer!.transform = CGAffineTransform.identity
        if (self.scaleBackgroundImageView!) {
            self.backgroundImageView!.transform = CGAffineTransform.identity
            self.backgroundImageView!.frame = self.view.bounds
        }
        self.menuViewContainer!.frame = self.view.bounds
        if (self.scaleMenuView!) {
            self.menuViewContainer!.transform = self.menuViewControllerTransformation!
        }
        self.menuViewContainer!.alpha = !self.fadeMenuView! ? 1 : 0
        if (self.scaleBackgroundImageView!) {
            self.backgroundImageView!.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
        }
        self.delegate?.sideMenu?(sideMenu: self, willShowMenuViewController: menuViewController)
    }
    
    
    func __showLeftMenuViewController() {
        if (self.leftMenuViewController == nil) {
            return
        }
        self.leftMenuViewController!.view.isHidden = false
        if (self.rightMenuViewController != nil) {
            self.rightMenuViewController!.view.isHidden = true
        }
        self.view.window!.endEditing(true)
        self.__addContentButton()
        self.__updateContentViewShadow()
        self.__resetContentViewScale()
        
        func _anim_doing() {
            if (self.scaleContentView!) {
                self.contentViewContainer!.transform = CGAffineTransform(scaleX: CGFloat(self.contentViewScaleValue!), y: CGFloat(self.contentViewScaleValue!))
            } else {
                
                self.contentViewContainer!.transform = CGAffineTransform.identity
            }
            self.contentViewContainer!.center = CGPoint(x: (UIInterfaceOrientationIsLandscape(UIApplication.shared().statusBarOrientation) ? self.contentViewInLandscapeOffsetCenterX! + self.view.frame.height : self.contentViewInPortraitOffsetCenterX! + self.view.frame.width), y: self.contentViewContainer!.center.y);
            
            self.menuViewContainer!.alpha = !self.fadeMenuView! ? 0 : 1.0
            self.menuViewContainer!.transform = CGAffineTransform.identity
            if (self.scaleBackgroundImageView!) {
                self.backgroundImageView!.transform = CGAffineTransform.identity
            }
        }
        
        func _anim_complete(finish: Bool) {
            self.__addContentViewControllerMotionEffects()
            if (!self.visible!) {
                self.delegate?.sideMenu?(sideMenu: self, didShowMenuViewController: self.leftMenuViewController!)
            }
            self.visible = true
            self.leftMenuVisible = true
        }
    
        UIView.animate(withDuration: self.animationDuration!, animations: _anim_doing, completion: _anim_complete)
        self.__statusBarNeedsAppearanceUpdate()
    }
    
    func __showRightMenuViewController() {
        if (self.rightMenuViewController == nil) {
            return
        }
        if (self.leftMenuViewController != nil) {
            self.leftMenuViewController!.view.isHidden = true
        }
        self.rightMenuViewController!.view.isHidden = false
        self.view.window!.endEditing(true)
        self.__addContentButton()
        self.__updateContentViewShadow()
        self.__resetContentViewScale()
        UIApplication.shared().beginIgnoringInteractionEvents()
        func _anim_doing() {
            if (self.scaleContentView!) {
                self.contentViewContainer!.transform = CGAffineTransform(scaleX: self.contentViewScaleValue!, y: self.contentViewScaleValue!)
            } else {
                self.contentViewContainer!.transform = CGAffineTransform.identity
            }
            self.contentViewContainer!.center = CGPoint(x: (UIInterfaceOrientationIsLandscape(UIApplication.shared().statusBarOrientation) ? -self.contentViewInLandscapeOffsetCenterX! : -self.contentViewInPortraitOffsetCenterX!), y: self.contentViewContainer!.center.y)
            
            self.menuViewContainer!.alpha = !self.fadeMenuView! ? 0 : 1.0
            self.menuViewContainer!.transform = CGAffineTransform.identity
            if (self.scaleBackgroundImageView!) {
                self.backgroundImageView!.transform = CGAffineTransform.identity
            }
        }
        
        func _anim_complete(finish: Bool) {
            if (!self.rightMenuVisible!) {
                self.delegate?.sideMenu?(sideMenu: self, didShowMenuViewController: self.rightMenuViewController!)
            }
            self.visible = !(self.contentViewContainer!.frame.size.width == self.view.bounds.size.width && self.contentViewContainer!.frame.size.height == self.view.bounds.size.height && self.contentViewContainer!.frame.origin.x == 0 && self.contentViewContainer!.frame.origin.y == 0)
            self.rightMenuVisible = self.visible
            UIApplication.shared().endIgnoringInteractionEvents()
            self.__addContentViewControllerMotionEffects()
        }
        
        UIView.animate(withDuration: self.animationDuration!, animations: _anim_doing, completion: _anim_complete)
        self.__statusBarNeedsAppearanceUpdate()
    }
    
    func __hideViewController(viewController: UIViewController?) {
        viewController!.willMove(toParentViewController: nil)
        viewController!.view.removeFromSuperview()
        viewController!.removeFromParentViewController()
    }
    
    func __hideMenuViewControllerAnimated(animated: Bool) {
        var rightMenuVisible = self.rightMenuVisible
        self.delegate?.sideMenu?(sideMenu: self, willHideMenuViewController: rightMenuVisible! ? self.rightMenuViewController : self.leftMenuViewController)
        self.visible = false
        self.leftMenuVisible = false
        self.rightMenuVisible = false
        self.contentButton!.removeFromSuperview()
        weak var weakSelf = self;

        var animationBlock: () -> Void = {
            var strongSelf = weakSelf
            if (strongSelf == nil) {
                return
            }
            strongSelf!.contentViewContainer!.transform = CGAffineTransform.identity
            strongSelf!.contentViewContainer!.frame = strongSelf!.view.bounds
            if (strongSelf!.scaleMenuView!) {
                strongSelf!.menuViewContainer!.transform = strongSelf!.menuViewControllerTransformation!
            }
            strongSelf!.menuViewContainer!.alpha = !self.fadeMenuView! ? 1 : 0
            if (strongSelf!.scaleBackgroundImageView!) {
                strongSelf!.backgroundImageView!.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
            }
            if (strongSelf!.parallaxEnabled!) {
                for effect in strongSelf!.contentViewContainer!.motionEffects {
                    strongSelf!.contentViewContainer!.removeMotionEffect(effect)
                }
            }
        }
    
        var completionBlock: () -> Void = {
            var strongSelf = weakSelf;
            if (strongSelf == nil) {
                return
            }
            if (!strongSelf!.visible!) {
                strongSelf!.delegate?.sideMenu?(sideMenu: self, didHideMenuViewController: rightMenuVisible! ? strongSelf!.rightMenuViewController : strongSelf!.leftMenuViewController)
            }
        }
    
        if (animated) {
            UIApplication.shared().beginIgnoringInteractionEvents()
            func _anim_doing() {
                animationBlock()
            }
            
            func _anim_complete (finish: Bool) {
                UIApplication.shared().endIgnoringInteractionEvents()
                completionBlock()
            }
            UIView.animate(withDuration: self.animationDuration!, animations: _anim_doing, completion: _anim_complete)
            
        } else {
            animationBlock()
            completionBlock()
        }
        self.__statusBarNeedsAppearanceUpdate()
    }
    
    func __addContentButton() {
        if (self.contentButton!.superview != nil) {
            return
        }
    
        self.contentButton!.autoresizingMask = []
        self.contentButton!.frame = self.contentViewContainer!.bounds
        self.contentButton!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.contentViewContainer!.addSubview(self.contentButton!)
    }
    
    func __statusBarNeedsAppearanceUpdate() {
        func _anim_doing() {
            setNeedsStatusBarAppearanceUpdate()
        }
        UIView.animate(withDuration: 0.3, animations: _anim_doing)
    }
    
    func __updateContentViewShadow() {
        if (self.contentViewShadowEnabled!) {
            let layer = self.contentViewContainer!.layer
            let path = UIBezierPath(rect: layer.bounds)
            layer.shadowPath = path.cgPath
            layer.shadowColor = self.contentViewShadowColor!.cgColor
            layer.shadowOffset = self.contentViewShadowOffset!
            layer.shadowOpacity = Float(self.contentViewShadowOpacity!)
            layer.shadowRadius = self.contentViewShadowRadius!
        }
    }
    
    func __resetContentViewScale() {
        let t = self.contentViewContainer!.transform
        let scale = sqrt(t.a * t.a + t.c * t.c)
        let frame = self.contentViewContainer!.frame
        self.contentViewContainer!.transform = CGAffineTransform.identity
        self.contentViewContainer!.transform = CGAffineTransform(scaleX: scale, y: scale)
        self.contentViewContainer!.frame = frame
    }

    // =================================
    // ios7 motion
    // =================================

    func __addMenuViewControllerMotionEffects() {
        if (self.parallaxEnabled!) {
            if (self.menuViewContainer!.motionEffects.count != 0) {
                for effect in self.menuViewContainer!.motionEffects {
                    self.menuViewContainer!.removeMotionEffect(effect)
                }
            }
            let interpolationHorizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
            interpolationHorizontal.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue
            interpolationHorizontal.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue
    
            let interpolationVertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
            interpolationVertical.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue
            interpolationVertical.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue
    
            self.menuViewContainer!.addMotionEffect(interpolationHorizontal)
            self.menuViewContainer!.addMotionEffect(interpolationVertical)
        }
    }
    
    func __addContentViewControllerMotionEffects() {
        if (self.parallaxEnabled!) {
            for effect in self.contentViewContainer!.motionEffects {
                self.contentViewContainer!.removeMotionEffect(effect)
            }
            
            func _anim_doing() {
                let interpolationHorizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
                interpolationHorizontal.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                interpolationHorizontal.maximumRelativeValue = self.parallaxContentMaximumRelativeValue
                let interpolationVertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
                interpolationVertical.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                interpolationVertical.maximumRelativeValue = self.parallaxContentMaximumRelativeValue
                self.contentViewContainer!.addMotionEffect(interpolationHorizontal)
                self.contentViewContainer!.addMotionEffect(interpolationVertical)
            }
            UIView.animate(withDuration: 0.2, animations: _anim_doing)
        }
    }
    
    // =================================
    // gesture delegate
    // =================================
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (self.interactivePopGestureRecognizerEnabled! && (self.contentViewController is UINavigationController)) {
            let navigationController = self.contentViewController as! UINavigationController
            if (navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer!.isEnabled) {
                return false;
            }
        }
        
        if (self.panFromEdge! && (gestureRecognizer is UIPanGestureRecognizer) && !self.visible!) {
            let point = touch.location(in: gestureRecognizer.view)
            if (point.x < 20.0 || point.x > self.view.frame.size.width - 20.0) {
                return true
            } else {
                return false
            }
        }
        
        return true
    }
    

    // =================================
    // Pan gesture recognizer
    // =================================
    
    func __panGestureRecognized(recognizer: UIPanGestureRecognizer) {
        self.delegate?.sideMenu?(sideMenu: self, didRecognizePanGesture: recognizer)
        if (!self.panGestureEnabled!) {
            return
        }
        var point = recognizer.translation(in: self.view)
        if (recognizer.state == UIGestureRecognizerState.began) {
            self.__updateContentViewShadow()
            self.originalPoint = CGPoint(x: self.contentViewContainer!.center.x - self.contentViewContainer!.bounds.width / 2.0,
                                         y: self.contentViewContainer!.center.y - self.contentViewContainer!.bounds.height / 2.0)
            self.menuViewContainer!.transform = CGAffineTransform.identity
            if (self.scaleBackgroundImageView!) {
                self.backgroundImageView!.transform = CGAffineTransform.identity
                self.backgroundImageView!.frame = self.view.bounds
            }
            self.menuViewContainer!.frame = self.view.bounds
            self.__addContentButton()
            self.view.window!.endEditing(true)
            self.didNotifyDelegate = false
        }
    
        if (recognizer.state == UIGestureRecognizerState.changed) {
            var delta: CGFloat = 0.0
            if (self.visible!) {
                delta = self.originalPoint!.x != 0 ? (point.x + self.originalPoint!.x) / self.originalPoint!.x : 0
            } else {
                delta = point.x / self.view.frame.size.width
            }
            delta = min(fabs(delta), 1.6)
    
            var contentViewScale:CGFloat = self.scaleContentView! ? 1 - ((1 - self.contentViewScaleValue!) * delta) : 1
    
            var backgroundViewScale: CGFloat = 1.7 - (0.7 * delta)
            var menuViewScale: CGFloat = 1.5 - (0.5 * delta)
    
            if (!self.bouncesHorizontally!) {
                contentViewScale = max(contentViewScale, self.contentViewScaleValue!)
                backgroundViewScale = max(backgroundViewScale, 1.0)
                menuViewScale = max(menuViewScale, 1.0)
            }
    
            self.menuViewContainer!.alpha = !self.fadeMenuView! ? 0 : delta;
    
            if (self.scaleBackgroundImageView!) {
                self.backgroundImageView!.transform = CGAffineTransform(scaleX: backgroundViewScale, y: backgroundViewScale)
            }
    
            if (self.scaleMenuView!) {
                self.menuViewContainer!.transform = CGAffineTransform(scaleX: menuViewScale, y: menuViewScale)
            }
    
            if (self.scaleBackgroundImageView!) {
                if (backgroundViewScale < 1) {
                    self.backgroundImageView!.transform = CGAffineTransform.identity
                }
            }
    
            if (!self.bouncesHorizontally! && self.visible!) {
                if (self.contentViewContainer!.frame.origin.x > self.contentViewContainer!.frame.size.width / 2.0) {
                    point.x = min(0.0, point.x)
                }
                if (self.contentViewContainer!.frame.origin.x < -(self.contentViewContainer!.frame.size.width / 2.0)) {
                    point.x = max(0.0, point.x)
                }
            }

            if (point.x < 0) {
                point.x = max(point.x, -UIScreen.main().bounds.size.height)
            } else {
                point.x = min(point.x, UIScreen.main().bounds.size.height)
            }
            recognizer.setTranslation(point, in:self.view)
    
            if (!self.didNotifyDelegate!) {
                if (point.x > 0) {
                    if (!self.visible!) {
                        self.delegate?.sideMenu?(sideMenu: self, willShowMenuViewController: leftMenuViewController)
                    }
                }
                if (point.x < 0) {
                    if (!self.visible!) {
                        self.delegate?.sideMenu?(sideMenu: self, willShowMenuViewController: rightMenuViewController)
                    }
                }
                self.didNotifyDelegate = true
            }
    
            if (contentViewScale > 1) {
                let oppositeScale: CGFloat = (1 - (contentViewScale - 1))
                self.contentViewContainer!.transform = CGAffineTransform(scaleX: oppositeScale, y: oppositeScale)
                self.contentViewContainer!.transform = self.contentViewContainer!.transform.translateBy(x: point.x, y: 0)
            } else {
                self.contentViewContainer!.transform = CGAffineTransform(scaleX: contentViewScale, y: contentViewScale)
                self.contentViewContainer!.transform = self.contentViewContainer!.transform.translateBy(x: point.x, y: 0)
            }
            if (self.leftMenuViewController != nil) {
                self.leftMenuViewController!.view.isHidden = self.contentViewContainer!.frame.origin.x < 0
            }
            if (self.rightMenuViewController != nil) {
                self.rightMenuViewController!.view.isHidden = self.contentViewContainer!.frame.origin.x > 0
            }
    
            if (self.leftMenuViewController == nil && self.contentViewContainer!.frame.origin.x > 0) {
                self.contentViewContainer!.transform = CGAffineTransform.identity
                self.contentViewContainer!.frame = self.view.bounds
                self.visible = false
                self.leftMenuVisible = false
            } else if (self.rightMenuViewController == nil && self.contentViewContainer!.frame.origin.x < 0) {
                self.contentViewContainer!.transform = CGAffineTransform.identity
                self.contentViewContainer!.frame = self.view.bounds
                self.visible = false
                self.rightMenuVisible = false
            }
    
            self.__statusBarNeedsAppearanceUpdate()
        }
    
        if (recognizer.state == UIGestureRecognizerState.ended) {
            self.didNotifyDelegate = false
            
            if (self.panMinimumOpenThreshold! > 0 && ((self.contentViewContainer!.frame.origin.x < 0 && self.contentViewContainer!.frame.origin.x > CGFloat(-self.panMinimumOpenThreshold!)) || (self.contentViewContainer!.frame.origin.x > 0 && self.contentViewContainer!.frame.origin.x < CGFloat(self.panMinimumOpenThreshold!)))) {
                self.hideMenuViewController()
            } else if (self.contentViewContainer!.frame.origin.x == 0) {
                self.__hideMenuViewControllerAnimated(animated: false)
            } else {
                if (recognizer.velocity(in: self.view).x > 0) {
                    if (self.contentViewContainer!.frame.origin.x < 0) {
                        self.hideMenuViewController()
                    } else {
                        if (self.leftMenuViewController != nil) {
                            self.__showLeftMenuViewController()
                        }
                    }
                } else {
                    if (self.contentViewContainer!.frame.origin.x < 20) {
                        if (self.rightMenuViewController != nil) {
                            self.__showRightMenuViewController()
                        }
                    } else {
                        self.hideMenuViewController()
                    }
                }
            }
        }
    }
    
    // =================================
    // rotation
    // =================================
    override func shouldAutorotate() -> Bool {
        return self.contentViewController!.shouldAutorotate()
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if (self.visible!) {
            self.menuViewContainer!.bounds = self.view.bounds
            self.contentViewContainer!.transform = CGAffineTransform.identity
            self.contentViewContainer!.frame = self.view.bounds
            
            if (self.scaleContentView!) {
                self.contentViewContainer!.transform = CGAffineTransform(scaleX: self.contentViewScaleValue!, y: self.contentViewScaleValue!)
            } else {
                self.contentViewContainer!.transform = CGAffineTransform.identity
            }
            
            var center: CGPoint?
            if (self.leftMenuVisible!) {
                center = CGPoint(x: (UIDeviceOrientationIsLandscape(UIDevice.current().orientation) ? self.contentViewInLandscapeOffsetCenterX! + self.view.frame.height : self.contentViewInPortraitOffsetCenterX! + self.view.frame.width), y: self.contentViewContainer!.center.y)
            } else {
                center = CGPoint(x: (UIDeviceOrientationIsLandscape(UIDevice.current().orientation) ? -self.contentViewInLandscapeOffsetCenterX! : -self.contentViewInPortraitOffsetCenterX!), y: self.contentViewContainer!.center.y)
            }
            
            self.contentViewContainer!.center = center!
        }
        
        self.__updateContentViewShadow()
    }
    
    // =================================
    // status bar
    // =================================
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        var statusBarStyle = UIStatusBarStyle.default
        statusBarStyle = self.visible! ? self.menuPreferredStatusBarStyle! : self.contentViewController!.preferredStatusBarStyle()
        if (self.contentViewContainer!.frame.origin.y > 10) {
            statusBarStyle = self.menuPreferredStatusBarStyle!
        } else {
            statusBarStyle = self.contentViewController!.preferredStatusBarStyle()
        }
        return statusBarStyle
    }
    
    override func prefersStatusBarHidden() -> Bool {
        var statusBarHidden = false
        statusBarHidden = self.visible! ? self.menuPrefersStatusBarHidden! : self.contentViewController!.prefersStatusBarHidden()
        if (self.contentViewContainer!.frame.origin.y > 10) {
            statusBarHidden = self.menuPrefersStatusBarHidden!
        } else {
            statusBarHidden = self.contentViewController!.prefersStatusBarHidden()
        }
        return statusBarHidden
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        var statusBarAnimation = UIStatusBarAnimation.none
        statusBarAnimation = self.visible! ? self.leftMenuViewController!.preferredStatusBarUpdateAnimation() : self.contentViewController!.preferredStatusBarUpdateAnimation()
        if (self.contentViewContainer!.frame.origin.y > 10) {
            statusBarAnimation = self.leftMenuViewController!.preferredStatusBarUpdateAnimation()
        } else {
            statusBarAnimation = self.contentViewController!.preferredStatusBarUpdateAnimation()
        }

        return statusBarAnimation

    }
    

}

