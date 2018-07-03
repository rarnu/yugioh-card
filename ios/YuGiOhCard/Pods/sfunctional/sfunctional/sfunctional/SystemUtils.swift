//
//  SystemUtils.swift
//  sfunctional
//
//  Created by rarnu on 27/03/2018.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

public func isJailbreak() -> Bool {
    let files = ["/Application/Cydia.app", "/Application/limera1n.app", "/Application/greenpois0n.app", "/Application/blackra1n.app", "/Application/blacksn0w.app", "/application/redsn0w.app"]
    var ret = false
    let mgr = FileManager.default
    files.forEach { item in
        if (mgr.fileExists(atPath: item)) {
            ret = true
        }
    }
    return ret
}

public func isEmulator() -> Bool {
    return SysEmu.isEmulator()
}
