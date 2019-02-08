//
//  YGORequest2.swift
//  YGOAPI2
//
//  Created by rarnu on 2019/2/8.
//  Copyright © 2019 rarnu. All rights reserved.
//

import UIKit

public let BASE_URL = "https://www.ourocg.cn"
public let RES_URL = "http://ocg.resource.m2v.cn/%d.jpg"

public class YGORequest2: NSObject {
    
    public class func search(_ key: String, _ page: Int, _ callback:@escaping (String) -> Void) {
        let url = BASE_URL + "/search/\(key)/\(page)"
        request(url, callback)
    }
    
    public class func cardDetailWiki(_ hashid: String, _ callback:@escaping (String, String) -> Void) {
        var callbackcount = 0
        var dataData = ""
        var dataWiki = ""
        let urlData = BASE_URL + "/card/\(hashid)"
        let urlWiki = BASE_URL + "/card/\(hashid)/wiki"
        request(urlData) { str in
            dataData = str
            callbackcount += 1
        }
        request(urlWiki) { str in
            dataWiki = str
            callbackcount += 1
        }
        while callbackcount != 2 { }
        callback(dataData, dataWiki)
     }
    
    public class func cardDetail(_ hashid: String, _ callback:@escaping (String) -> Void) {
        let url = BASE_URL + "/card/\(hashid)"
        request(url, callback)
    }
    
    public class func cardWiki(_ hashid: String, _ callback:@escaping (String) -> Void) {
        let url = BASE_URL + "/card/\(hashid)/wiki"
        request(url, callback)
    }
    
    public class func limit(_ callback:@escaping (String) -> Void) {
        let url = BASE_URL + "/Limit-Latest"
        request(url, callback)
    }
    
    public class func packageList(_ callback:@escaping (String) -> Void) {
        let url = BASE_URL + "/package"
        request(url, callback)
    }
    
    public class func packageDetail(_ url: String, _ callback:@escaping (String) -> Void) {
        let url2 = BASE_URL + url
        request(url2, callback)
    }
    
    public class func hotest(_ callback:@escaping (String) -> Void) {
        request(BASE_URL, callback)
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
