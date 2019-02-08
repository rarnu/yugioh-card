//
//  ContextUtils.swift
//  sfunctional
//
//  Created by rarnu on 26/03/2018.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

public func systemVersion() -> String {
    return UIDevice.current.systemVersion
}

public func systemName() -> String {
    return UIDevice.current.systemName
}

public func appVersion() -> String {
    return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
}

public func screenSize() -> CGSize {
    return UIScreen.main.bounds.size
}

public func screenWidth() -> CGFloat {
    return UIScreen.main.bounds.size.width
}

public func screenHeight() -> CGFloat {
    return UIScreen.main.bounds.size.height
}

public func statusbarSize() -> CGSize {
    return UIApplication.shared.statusBarFrame.size
}

public func readConfig(key: String, def: String?) -> String? {
    var v: String? = UserDefaults.standard.value(forKey: key) as? String
    if (v == nil) {
        v = def
    }
    return v
}

public func writeConfig(key: String, value: String?) {
    UserDefaults.standard.setValue(value, forKey: key)
}

public func readConfig(key: String, def: Int) -> Int {
    var v: Int? = UserDefaults.standard.value(forKey: key) as? Int
    if (v == nil) {
        v = def
    }
    return v!
}

public func writeConfig(key: String, value: Int) {
    UserDefaults.standard.setValue(value, forKey: key)
}

public func readConfig(key: String, def: Float) -> Float {
    var v: Float? = UserDefaults.standard.value(forKey: key) as? Float
    if (v == nil) {
        v = def
    }
    return v!
}

public func writeConfig(key: String, value: Float) {
    UserDefaults.standard.setValue(value, forKey: key)
}

public func readConfig(key: String, def: CLongLong) -> CLongLong {
    var v: CLongLong? = UserDefaults.standard.value(forKey: key) as? CLongLong
    if (v == nil) {
        v = def
    }
    return v!
}

public func writeConfig(key: String, value: CLongLong) {
    UserDefaults.standard.setValue(value, forKey: key)
}

public func readConfig(key: String, def: Bool) -> Bool {
    var v: Bool? = UserDefaults.standard.value(forKey: key) as? Bool
    if (v == nil) {
        v = def
    }
    return v!
}

public func writeConfig(key: String, value: Bool) {
    UserDefaults.standard.setValue(value, forKey: key)
}

