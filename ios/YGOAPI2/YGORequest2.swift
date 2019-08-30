//
//  YGORequest2.swift
//  YGOAPI2
//
//  Created by rarnu on 2019/2/8.
//  Copyright © 2019 rarnu. All rights reserved.
//

import UIKit

public let BASE_URL = "https://rarnu.xyz"
public let RES_URL = "http://ocg.resource.m2v.cn/%d.jpg"

public class YGORequest2: NSObject {
    
    public class func search(_ key: String, _ page: Int, _ callback:@escaping (String) -> Void) {
        request(BASE_URL + "/search?key=\(key)&page=\(page)", callback)
    }
    
    public class func cardDetailWiki(_ hashid: String, _ callback:@escaping (String, String, String) -> Void) {
        request(BASE_URL + "/carddetail?hash=\(hashid)") { str in
            let sarr = str.split(by: "\\\\\\\\")
            callback(sarr[0], sarr[1], sarr[2])
        }
     }
    
    public class func limit(_ callback:@escaping (String) -> Void) {
        request(BASE_URL + "/limit", callback)
    }
    
    public class func packageList(_ callback:@escaping (String) -> Void) {
        request(BASE_URL + "/packlist", callback)
    }
    
    public class func packageDetail(_ url: String, _ callback:@escaping (String) -> Void) {
        request(BASE_URL + "/packdetail?url=\(url)", callback)
    }
    
    public class func hotest(_ callback:@escaping (String) -> Void) {
        request(BASE_URL + "/hotest", callback)
    }
    
    public class func deckTheme(_ callback:@escaping (String) -> Void) {
        request(BASE_URL + "/decktheme", callback)
    }
    
    public class func deckCategory(_ callback:@escaping (String) -> Void) {
        request(BASE_URL + "/deckcategory", callback)
    }
    
    public class func deckInCategory(_ hash: String, _ callback: @escaping (String) -> Void) {
        request(BASE_URL + "/deckincategory?hash=\(hash)", callback)
    }
    
    public class func deck(_ code: String, _ callback:@escaping (String) -> Void) {
        request(BASE_URL + "/deck?code=\(code)", callback)
    }
    
    private class func request(_ url: String, _ callback:@escaping (String) -> Void) {
        let url2 = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let req = URLRequest(url: URL(string: url2)!)
        let task = URLSession.shared.dataTask(with: req) { data, resp, err in
            var retstr = ""
            if (err == nil && data != nil) {
                retstr = String(data: data!, encoding: .utf8)!
            }
            callback(retstr)
        }
        task.resume()
    }
}

extension String {
    func indexOf(sub: String) -> Int {
        var i = -1
        let r = self.range(of: sub)
        if (r != nil) {
            i = r!.lowerBound.utf16Offset(in: self)
        }
        return i
    }
    
    func sub(start: Int) -> String {
        var tmp = self
        tmp = String(tmp[tmp.index(tmp.startIndex, offsetBy: start)...])
        return tmp
    }
    
    func sub(start: Int, length: Int) -> String {
        var tmp = self
        tmp = String(tmp[tmp.index(tmp.startIndex, offsetBy: start)..<tmp.index(tmp.startIndex, offsetBy: start + length)])
        return tmp
    }
    
    func split(by: String) -> [String] {
        var arr = [String]()
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
