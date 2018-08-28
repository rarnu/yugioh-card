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

public extension String {
    // TODO: string extension
    mutating func insert(idx: Int, sub: String) -> String {
        var tmp = self
        tmp.insert(contentsOf: sub, at: tmp.index(tmp.startIndex, offsetBy: idx))
        return tmp
    }
    
    mutating func remove(idx: Int, length: Int) -> String {
        var tmp = self
        tmp.removeSubrange(tmp.index(tmp.startIndex, offsetBy: idx)..<tmp.index(tmp.startIndex, offsetBy: idx + length))
        return tmp
    }
    
    mutating func sub(start: Int) -> String {
        var tmp = self
        tmp = String(tmp[tmp.index(tmp.startIndex, offsetBy: start)...])
        return tmp
    }
    
    mutating func sub(start: Int, length: Int) -> String {
        var tmp = self
        tmp = String(tmp[tmp.index(tmp.startIndex, offsetBy: start)..<tmp.index(tmp.startIndex, offsetBy: start + length)])
        return tmp
    }

    func indexOf(sub: String) -> Int {
        var i = -1
        let r = self.range(of: sub)
        if (r != nil) {
            i = r!.lowerBound.encodedOffset
        }
        return i
    }
    
    func indexOf(sub: String, start: Int) -> Int {
        var tmp = self
        tmp = tmp.sub(start: start)
        var i = -1
        let idx = tmp.indexOf(sub: sub)
        if (idx != -1) {
            i = idx + start
        }
        return i
    }
    
    func lastIndexOf(sub: String) -> Int {
        var i = self.count - sub.count
        var tmp = self
        var found = false
        while (!found) && (i > 0) {
            if (tmp.sub(start: i, length: sub.count) == sub) {
                found = true
                break
            }
            i -= 1
        }
        if (!found) {
            i = -1
        }
        return i
        
    }
    
    mutating func trim() -> String {
        var tmp = self
        tmp = tmp.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return tmp
    }
    
    mutating func trim(c: Array<String>) -> String {
        var tmp = self
        var s = ""
        for ch in c {
            s.append(ch)
        }
        tmp = tmp.trimmingCharacters(in: CharacterSet(charactersIn: s))
        return tmp
    }
    
    func split(by: String) -> Array<String> {
        var arr = Array<String>()
        var tmp = self
        var idx = -1
        while true {
            idx = tmp.indexOf(sub: by)
            if (idx != -1) {
                let t = tmp.sub(start: 0, length: idx)
                arr.append(t)
                tmp = tmp.sub(start: idx + by.count)
            } else {
                arr.append(tmp)
                break
            }
        }
        return arr
    }
}

public extension UIColor {
    func parseString(_ colorStr: String) -> UIColor {
        var color = UIColor.red
        var cStr : String = colorStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cStr.hasPrefix("#") {
            let index = cStr.index(after: cStr.startIndex)
            cStr = String(cStr[index...])
        }
        if cStr.count != 6 {
            return UIColor.black
        }
        let rRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2)
        let rStr = String(cStr[rRange])
        let gRange = cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4)
        let gStr = String(cStr[gRange])
        let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)
        let bStr = String(cStr[bIndex...])
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
        return color
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
