//
//  UIUtils.swift
//  YuGiOhCard
//
//  Created by rarnu on 3/26/15.
//  Copyright (c) 2015 rarnu. All rights reserved.
//

import UIKit

class UIUtils: NSObject {
    
    class func setStatusBar(light: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(light ? UIStatusBarStyle.LightContent : UIStatusBarStyle.Default, animated: false)
    }
    
    class func setNavBar(nav: UINavigationBar) {
        nav.barTintColor = UIColor.clearColor()
        nav.tintColor = UIColor.whiteColor()
        nav.titleTextAttributes = NSDictionary(objectsAndKeys: UIColor.whiteColor(), NSForegroundColorAttributeName)
        nav.setBackgroundImage(UIImage(named: "navbg"), forBarMetrics: UIBarMetrics.Default)
    }
    
    class func setTabBar(tab: UITabBar) {
        tab.translucent = true
        tab.backgroundImage = UIImage(named: "navbg")
        tab.tintColor = UIColor.whiteColor()
    }
}
