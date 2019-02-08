//
//  Dictionary+StringInt.swift
//  YGOAPI2
//
//  Created by rarnu on 2019/2/9.
//  Copyright © 2019 rarnu. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func string(_ key: Key) -> String {
        let v = self[key]
        let ret = "\(v!)"
        return ret
    }
    
    func int(_ key: Key) -> Int {
        let v = self[key]
        let s = "\(v!)"
        let ret = Int(s)!
        return ret
    }
}

