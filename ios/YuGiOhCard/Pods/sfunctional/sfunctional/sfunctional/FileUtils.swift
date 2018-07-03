//
//  FileUtils.swift
//  sfunctional
//
//  Created by rarnu on 26/03/2018.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

public func documentPath(_ withSeparator: Bool = false) -> String {
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
    var p = paths[0]
    if (withSeparator) {
        p += "/"
    }
    return p
}

public func fileIO(src: Any, dest: Any, isSrcText: Bool = false, isDestText: Bool = false, _ result: @escaping (_ succ: Bool, _ data: Any?, _ error: String?) -> Void) {
    FileOperations.fileIO(src, dest, isSrcText, isDestText, result)
}

private class FileOperations {
    
    private static let ERROR_SRC = "Src Type Error"
    private static let ERROR_DEST = "Dest Type Error"
    
    class func fileIO(_ src: Any, _ dest: Any, _ isSrcText: Bool, _ isDestText: Bool,_  result:@escaping (_ succ: Bool, _ data: Any?, _ error: String?) -> Void) {
        if (isSrcText) {
            textIOAny(src as! String, dest, isDestText, result)
        } else {
            if (src is String) {
                fileIOAny(src as! String, dest, isDestText, result)
            } else if (src is Data) {
                dataIOAny(src as! Data, dest, isDestText, result)
            } else {
                result(false, nil, ERROR_SRC)
            }
        }
    }
    
    private class func fileIOAny(_ file: String, _ dest: Any, _ isDestText: Bool, _ result:(_ succ: Bool, _ data: Any?, _ error: String?) -> Void) {
        if (isDestText) {
            do {
                let text = try String(contentsOfFile: file, encoding: .utf8)
                result(true, text, nil)
            } catch {
                result(false, nil, error.localizedDescription)
            }
        } else {
            if (dest is String) {
                let adata = NSData(contentsOfFile: file)!
                adata.write(toFile: dest as! String, atomically: true)
                result(true, nil, nil)
            } else if (dest is Data) {
                let adata = NSData(contentsOfFile: file)! as Data
                result(true, adata, nil)
            } else {
                result(false, nil, ERROR_DEST)
            }
        }
    }
    
    private class func dataIOAny(_ data: Data, _ dest: Any, _ isDestText: Bool, _ result:(_ succ: Bool, _ data: Any?, _ error: String?) -> Void) {
        if (isDestText) {
            let text = String(data: data, encoding: .utf8)
            result(true, text, nil)
        } else {
            if (dest is String) {
                var ret = (data as NSData?)?.write(toFile: dest as! String, atomically: true)
                if (ret == nil) {
                    ret = false
                }
                result(ret!, nil, nil)
            } else if (dest is Data) {
                result(true, dest, nil)
            } else {
                result(false, nil, ERROR_DEST)
            }
        }
    }
    
    private class func textIOAny(_ text: String, _ dest: Any, _ isDestText: Bool, _ result:(_ succ: Bool, _ data: Any?, _ error: String?) -> Void) {
        if (isDestText) {
            result(true, text, nil)
        } else {
            if (dest is String) {
                let d = text.data(using: .utf8)
                var ret = (d as NSData?)?.write(toFile: dest as! String, atomically: true)
                if (ret == nil) {
                    ret = false
                }
                result(ret!, nil, nil)
            } else if (dest is Data) {
                let d = text.data(using: .utf8)
                result(true, d, nil)
            } else {
                result(false, nil, ERROR_DEST)
            }
        }
    }
}
