//
//  BundleUtils.swift
//  sfunctional
//
//  Created by rarnu on 27/03/2018.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit


public func bundleFilePath(_ filename: String) -> String {
    let p = Bundle.main.path(forResource: filename, ofType: "")
    return p == nil ? "" : p!
}

public func bundleIO(filename: String, dest: Any, isDestText: Bool = false, _ result: @escaping (_ succ: Bool, _ data: Any?, _ error: String?) -> Void) {
    BundleOperations.bundleIO(filename: filename, dest: dest, isDestText: isDestText, result)
}

private class BundleOperations {
    
    static let BUNDLE_ERROR = "Bundle file not found"
    
    class func bundleIO(filename: String, dest: Any, isDestText: Bool = false, _ result: @escaping (_ succ: Bool, _ data: Any?, _ error: String?) -> Void) {
        let realFile = Bundle.main.path(forResource: filename, ofType: "")
        if (realFile == nil) {
            result(false, nil, BUNDLE_ERROR)
            return
        }
        if (isDestText) {
            do {
                let text = try String(contentsOfFile: realFile!)
                result(true, text, nil)
            } catch {
                result(false, nil, error.localizedDescription)
            }
        } else {
            if (dest is String) {
                let mgr = FileManager.default
                do {
                    try mgr.copyItem(atPath: realFile!, toPath: dest as! String)
                    result(true, nil, nil)
                } catch {
                    result(false, nil, error.localizedDescription)
                }
                
            } else if (dest is Data) {
                let d = NSData(contentsOfFile: realFile!)! as Data
                result(true, d, nil)
            }
        }
    }
}

