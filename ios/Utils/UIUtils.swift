//
//  UIUtils.swift
//  YuGiOhCard
//
//  Created by rarnu on 3/26/15.
//  Copyright (c) 2015 rarnu. All rights reserved.
//

import UIKit

var widthDelta: CGFloat?

var autoSizeScaleX: CGFloat?
var autoSizeScaleY: CGFloat?

class UIUtils: NSObject {
    
    class func setStatusBar(light: Bool) {
        UIApplication.shared.setStatusBarStyle(light ? UIStatusBarStyle.lightContent : UIStatusBarStyle.default, animated: false)
    }
    
    class func setNavBar(nav: UINavigationBar) {
        nav.barTintColor = UIColor.clear
        nav.tintColor = UIColor.white
        nav.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white] // NSDictionary(object: UIColor.white, forKey: NSForegroundColorAttributeName)
        nav.setBackgroundImage(UIImage(named: "navbg"), for: UIBarMetrics.default)
    }
    
    class func setTabBar(tab: UITabBar) {
        tab.isTranslucent = true
        tab.backgroundImage = UIImage(named: "navbg")
        tab.tintColor = UIColor.white
    }
    
    class func getScreenSize() -> (CGFloat, CGFloat) {
        let size = UIScreen.main.bounds.size
        return (size.width, size.height)
    }
    
    class func getWidthDelta() {
        let (screenWidth, screenHeight) = UIUtils.getScreenSize()
        widthDelta = screenWidth - 320;
        
        if (screenHeight > 480) {
            autoSizeScaleX = screenWidth / 320
            autoSizeScaleY = screenHeight / 568
        } else {
            autoSizeScaleX = 1.0
            autoSizeScaleY = 1.0
        }
    }
    
    class func resizeComponent(view: UIView) {
        if (widthDelta != nil) {
            view.frame.size.width = view.frame.size.width + widthDelta!
        }
    }
    
    class func resizeComponent(view: UIView, percent: CGFloat, leftOffset: Bool) {
        if (widthDelta != nil) {
            view.frame.size.width = view.frame.size.width + (widthDelta! * percent)
            if (leftOffset) {
                view.frame.origin.x = view.frame.origin.x + (widthDelta! * percent)
            }
        }
    }
    
    class func scaleComponent(view: UIView) {
        var rect = view.frame
        rect.origin.x = rect.origin.x * autoSizeScaleX!
        rect.origin.y = rect.origin.y * autoSizeScaleY!
        rect.size.width = rect.size.width * autoSizeScaleX!
        rect.size.height = rect.size.height * autoSizeScaleY!
        view.frame = rect
    }
    
    class func setTextFieldCursorColor(color: UIColor) {
        UITextField.appearance().tintColor = color
    }
    
}
