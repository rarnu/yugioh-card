//
//  Updater.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/23.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import sfunctional

class Updater: NSObject {
    private static let VERSIONCODE = 2
    private static let UPDATE_URL = "https://github.com/rarnu/yugioh-card/raw/master/update/update.json"
    
    class func checkUpdate(vc: UIViewController) {
        http(UPDATE_URL) { (code, result, error) in
            if (code == 200 && result != nil) {
                do {
                    let json = try JSONSerialization.jsonObject(with: result!.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: Any]
                    let jobj = json["ios"] as! [String: Any]
                    if ((jobj["code"] as! Int) > VERSIONCODE) {
                        vc.mainThread {
                            vc.alert(title: "升级", message: "发现新版本，点击<确定>访问最新源码", btn1: "确定", btn2: "取消") { (which) in
                                let u = URL(string: "https://github.com/rarnu/yugioh-card")
                                if #available(iOS 10, *) {
                                    UIApplication.shared.open(u!, options:[:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(u!)
                                }
                                
                            }
                        }
                    }
                    
                } catch {
                    
                }
            }
        }
    }
}
