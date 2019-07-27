//
//  Dictionary+StringInt.swift
//  YGOAPI2
//
//  Created by rarnu on 2019/2/9.
//  Copyright © 2019 rarnu. All rights reserved.
//

import Foundation

postfix operator >~<
postfix func >~< (_ input: Any) -> Dictionary<String, Any> {
    return input as! Dictionary<String, Any>
}

postfix operator >|<
postfix func >|< (_ input: Any) -> Array<Dictionary<String, Any>> {
    return input as! Array<Dictionary<String, Any>>
}

postfix operator >^<
postfix func >^< (_ input: Any) -> Array<String> {
    return input as! Array<String>
}

extension Dictionary {
    
    func string(_ key: Key) -> String {
        let v = self[key]
        let ret = "\(v!)"
        return ret
    }
    
    func int(_ key: Key) -> Int {
        let v = self[key]
        let s = "\(v!)"
        var ret = 0
        if (s != "") {
            ret = Int(s)!
        }
        return ret
    }
}

