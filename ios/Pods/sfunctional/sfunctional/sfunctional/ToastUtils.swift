//
//  ToastUtils.swift
//  sfunctional
//
//  Created by rarnu on 2018/7/3.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

let mainWidth = UIScreen.main.bounds.size.width
let mainHeight = UIScreen.main.bounds.size.height

public class Toast {
    static var toastLabel : UILabel?
    class func currentToastLabel() -> UILabel {
        objc_sync_enter(self)
        if toastLabel == nil {
            toastLabel = UILabel.init()
            toastLabel?.backgroundColor = UIColor.darkGray
            toastLabel?.font = UIFont.systemFont(ofSize: 16)
            toastLabel?.textColor = UIColor.white
            toastLabel?.numberOfLines = 0;
            toastLabel?.textAlignment = .center
            toastLabel?.lineBreakMode = .byCharWrapping
            toastLabel?.layer.masksToBounds = true
            toastLabel?.layer.cornerRadius = 5.0
            toastLabel?.alpha = 0;
        }
        objc_sync_exit(self)
        return toastLabel!
    }
    class func stringText(aText : NSString?, aFont : CGFloat, isHeightFixed : Bool, fixedValue : CGFloat) -> CGFloat {
        var size = CGSize.zero
        if isHeightFixed == true {
            size = CGSize.init(width: CGFloat(MAXFLOAT), height: fixedValue)
        }else{
            size = CGSize.init(width: fixedValue, height: CGFloat(MAXFLOAT))
        }
        let resultSize = aText?.boundingRect(with: size, options: (NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue)), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: aFont)], context: nil).size
        if isHeightFixed == true {
            return resultSize!.width + 20
        } else {
            return resultSize!.height + 20
        }
    }
    class func showToast(message : NSString?) {
        if Thread.current.isMainThread {
            toastLabel = self.currentToastLabel()
            toastLabel?.removeFromSuperview()
            
            // let AppDlgt = UIApplication.shared.delegate as! AppDelegate
            // AppDlgt.window?.addSubview(toastLabel!)
            UIApplication.shared.delegate?.window??.addSubview(toastLabel!)
            
            var width = self.stringText(aText: message, aFont: 16, isHeightFixed: true, fixedValue: 40)
            var height : CGFloat = 0
            if width > (mainWidth - 20) {
                width = mainWidth - 20
                height = self.stringText(aText: message, aFont: 16, isHeightFixed: false, fixedValue: width)
            }else{
                height = 40
            }
            let labFrame = CGRect.init(x: (mainWidth-width)/2, y: mainHeight*0.85, width: width, height: height)
            toastLabel?.frame = labFrame
            toastLabel?.text = message as String?
            toastLabel?.alpha = 1
            UIView.animate(withDuration: 2.0, animations: {
                toastLabel?.alpha = 0;
            })
        }else{
            DispatchQueue.main.async {
                self.showToast(message: message)
            }
            return
        }
    }
}
