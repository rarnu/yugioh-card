//
//  YGOCache2.swift
//  YGOAPI2
//
//  Created by rarnu on 2019/2/8.
//  Copyright © 2019 rarnu. All rights reserved.
//

import UIKit

public class YGOCache2: NSObject {

    public class func loadCache(_ hashid: String, _ type: Int) -> String {
        var ret = ""
        let path = getCachePath() + "\(hashid)_\(type).data"
        let mgr = FileManager.default
        if (mgr.fileExists(atPath: path)) {
            do {
                ret = try String(contentsOfFile: path, encoding: .utf8)
            } catch {
                
            }
        }
        return ret
    }
    
    public class func saveCache(_ hashid: String, _ type: Int, _ text: String) {
        let path = getCachePath() + "\(hashid)_\(type).data"
        (text.data(using: .utf8)! as NSData).write(toFile: path, atomically: true)
    }
    
    public class func cleanCache() {
        let mgr = FileManager.default
        let path = getCachePath()
        do {
            let files = try mgr.contentsOfDirectory(atPath: path)
            for f in files {
                let filepath = path + f
                try mgr.removeItem(atPath: filepath)
            }
        } catch {
            
        }
    }
    
    private class func getCachePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let p = paths[0] + "/cache/"
        let mgr = FileManager.default
        if (!mgr.fileExists(atPath: p)) {
            do {
                try mgr.createDirectory(atPath: p, withIntermediateDirectories: true, attributes: nil)
            } catch {
                
            }
        }
        return p
    }
}
