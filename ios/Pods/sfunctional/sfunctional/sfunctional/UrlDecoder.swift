//
//  UrlDecoder.swift
//  sfunctional
//
//  Created by rarnu on 2018/5/16.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

public class UrlInfo {
    public var host = ""
    public var port = 80
    public var proto = "http"
    public var uri = ""
    public var params = Dictionary<String, String>()
}

public func decodeUrl(_ url: String) -> UrlInfo {
    var innerUrl = url
    let info = UrlInfo()
    if (innerUrl.contains("://")) {
        // find protocol
        let idx = innerUrl.firstIndex(of: ":")!
        let p = String(innerUrl[..<idx])
        info.proto = p
        if (p == "http") {
            info.port = 80
        } else if (p == "https") {
            info.port = 443
        }
        innerUrl = String(innerUrl[idx...].dropFirst(3))
    }
    
    if (innerUrl.contains("/")) {
        // find uri or params
        let idx = innerUrl.firstIndex(of: "/")!
        var sub = String(innerUrl[idx...].dropFirst())
        if (sub.contains("?")) {
            // find params
            let idxParam = sub.firstIndex(of: "?")!
            let paramStr = String(sub[idxParam...].dropFirst())
            let ps = paramStr.split(separator: "&")
            for s in ps {
                let p = s.split(separator: "=")
                if (p.count == 1) {
                    info.params[String(p[0])] = ""
                } else {
                    info.params[String(p[0])] = String(p[1])
                }
            }
            sub = String(sub[..<idxParam])
        }
        // treat uri
        info.uri = sub
        // slice to host and port
        innerUrl = String(innerUrl[..<idx])
    }
    
    if (innerUrl.contains(":")) {
        // find port
        let idx = innerUrl.firstIndex(of: ":")!
        let p = String(innerUrl[idx...].dropFirst())
        info.port = Int(p)!
        innerUrl = String(innerUrl[..<idx])
    }
    
    info.host = innerUrl
    return info
}


