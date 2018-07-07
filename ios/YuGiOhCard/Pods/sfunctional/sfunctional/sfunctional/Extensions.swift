//
//  Object+Queue.swift
//  sfunctional
//
//  Created by rarnu on 26/03/2018.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

public extension NSObject {
    func thread(_ b:@escaping () -> Void) {
        Thread.detachNewThread(b)
    }
    func mainThread(_ b:@escaping () -> Void) {
        OperationQueue.main.addOperation(b)
    }
}

public extension UIView {
    func toast(msg: String) {
        Toast.showToast(message: msg as NSString?)
    }
    
    func viewController() -> UIViewController? {
        var result: UIViewController? = nil
        var responder = self.next
        while (true) {
            if (responder != nil) {
                if (!responder!.isKind(of: UIViewController.classForCoder()) && !responder!.isKind(of: UIWindow.classForCoder())) {
                    responder = responder!.next
                } else {
                    break
                }
            } else {
                break
            }
        }
        if (responder != nil) {
            if (responder!.isKind(of: UIViewController.classForCoder())) {
                result = responder as? UIViewController
            }
        }
        return result
    }
}

public extension UIViewController {
    func navigationbarHeight() -> CGFloat {
        let h = navigationController?.navigationBar.frame.size.height
        return (h == nil) ? 0 : h!
    }
    
    func vc(name: String) -> UIViewController? {
        return self.storyboard?.instantiateViewController(withIdentifier:name)
    }
    
    func alert(title: String, message: String, btn: String, callback:@escaping () -> Void) {
        let a = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        a.addAction(UIAlertAction(title: btn, style: UIAlertActionStyle.default, handler: { _ in
            callback()
        }))
        present(a, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, btn1: String, btn2: String, callback:@escaping (_ which: Int) -> Void) {
        let a = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        a.addAction(UIAlertAction(title: btn1, style: UIAlertActionStyle.default, handler: { _ in
            callback(0)
        }))
        a.addAction(UIAlertAction(title: btn2, style: UIAlertActionStyle.cancel, handler: { _ in
            callback(1)
        }))
        present(a, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, btn1: String, btn2: String, btn3: String, callback: @escaping (_ which: Int) -> Void) {
        let a = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        a.addAction(UIAlertAction(title: btn1, style: UIAlertActionStyle.default, handler: { _ in
            callback(0)
        }))
        a.addAction(UIAlertAction(title: btn2, style: UIAlertActionStyle.cancel, handler: { _ in
            callback(1)
        }))
        a.addAction(UIAlertAction(title: btn3, style: UIAlertActionStyle.destructive, handler: { _ in
            callback(2)
        }))
        present(a, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, btn1: String, btn2: String, placeholder: String, initText: String, callback: @escaping (_ which: Int, _ text: String?) -> Void) {
        let a = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        a.addTextField(configurationHandler: {tf in
            tf.placeholder = placeholder
            tf.text = initText
        })
        a.addAction(UIAlertAction(title: btn1, style: UIAlertActionStyle.default, handler: { _ in
            callback(0, a.textFields![0].text)
        }))
        a.addAction(UIAlertAction(title: btn2, style: UIAlertActionStyle.cancel, handler: { _ in
            callback(1, a.textFields![0].text)
        }))
        present(a, animated: true, completion: nil)
    }
    
}