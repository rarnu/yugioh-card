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
        httpGet(BASE_URL + "/search?key=\(key)&page=\(page)") { (_, result, _) in
            callback(result)
        }
    }
    
    public class func cardDetailWiki(_ hashid: String, _ callback:@escaping (String, String, String) -> Void) {
        httpGet(BASE_URL + "/carddetail?hash=\(hashid)") { (_, result, _) in
            let sarr = result.split(by: "\\\\\\\\")
            callback(sarr[0], sarr[1], sarr[2])
        }
     }
    
    public class func limit(_ callback:@escaping (String) -> Void) {
        httpGet(BASE_URL + "/limit") { (_, result, _) in
            callback(result)
        }
    }
    
    public class func packageList(_ callback:@escaping (String) -> Void) {
        httpGet(BASE_URL + "/packlist") { (_, result, _) in
            callback(result)
        }
    }
    
    public class func packageDetail(_ url: String, _ callback:@escaping (String) -> Void) {
        httpGet(BASE_URL + "/packdetail?url=\(url)") { (_, result, _) in
            callback(result)
        }
    }
    
    public class func hotest(_ callback:@escaping (String) -> Void) {
        httpGet(BASE_URL + "/hotest") { (_, result, _) in
            callback(result)
        }
    }
    
    public class func deckTheme(_ callback:@escaping (String) -> Void) {
        httpGet(BASE_URL + "/decktheme") { (_, result, _) in
            callback(result)
        }
    }
    
    public class func deckCategory(_ callback:@escaping (String) -> Void) {
        httpGet(BASE_URL + "/deckcategory") { (_, result, _) in
            callback(result)
        }
    }
    
    public class func deckInCategory(_ hash: String, _ callback: @escaping (String) -> Void) {
        httpGet(BASE_URL + "/deckincategory?hash=\(hash)") { (_, result, _) in
            callback(result)
        }
    }
    
    public class func deck(_ code: String, _ callback:@escaping (String) -> Void) {
        httpGet(BASE_URL + "/deck?code=\(code)") { (_, result, _) in
            callback(result)
        }
    }
    
    public class func findImageByImageId(_ imgid: String, _ callback:@escaping (String) -> Void) {
        httpGet(BASE_URL + "/findbyimage?imgid=\(imgid)") { (_, result, _) in
            callback(result)
        }
    }
    
    public class func imageSearch(_ file: String, _ callback:@escaping (String) -> Void) {
        http(BASE_URL + "/matchimage", method: "POST", fileParam:["file":file]) { (_, result, _) in
            callback(result)
        }
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


func http(_ url: String, method: String = "GET", mimeType: String = "text/json", data: String = "", getParam: String? = nil, postParam: Dictionary<String, String>? = nil, fileParam: Dictionary<String, String>? = nil, _ callback:@escaping (_ code: Int, _ result: String, _ error: String) -> Void) {
    var fullurl = url
    if (getParam != nil && getParam != "") {
        fullurl += "?\(getParam!)"
    }
    let req = HttpOperations.buildRequest(fullurl, method, mimeType, data, postParam, fileParam)
    let session = URLSession.shared
    let task = (fileParam == nil) ? (
        session.dataTask(with: req) { (data, respond, error) in
            let resp = respond as? HTTPURLResponse
            let code = (resp != nil) ? resp!.statusCode : 0
            let result = (data != nil) ? String(data: data!, encoding:.utf8)! : ""
            let err = error != nil ? "\(error!)" : ""
            callback(code, result, err)
        }) : (
        session.uploadTask(with: req, from: nil) { (data, respond, error) in
            let resp = respond as? HTTPURLResponse
            let code = (resp != nil) ? resp!.statusCode : 0
            let result = (data != nil) ? String(data: data!, encoding:.utf8)! : ""
            let err = error != nil ? "\(error!)" : ""
            callback(code, result, err)
        })
    task.resume()
}

func httpGet(_ url: String, _ callback:@escaping (_ code: Int, _ result: String, _ error: String) -> Void) {
    http(url, callback)
}

func httpPost(_ url: String, postParam: Dictionary<String, String>? = nil, _ callback:@escaping (_ code: Int, _ result: String, _ error: String) -> Void) {
    http(url, postParam: postParam, callback)
}

func blockingHttp(_ url: String, method: String = "GET", mimeType: String = "text/json", data: String = "", getParam: String? = nil, postParam: Dictionary<String, String>? = nil, fileParam: Dictionary<String, String>? = nil, _ callback:((_ code: Int, _ result: String, _ error: String) -> Void)? = nil) -> String {
    let semaphore = DispatchSemaphore.init(value: 0)
    var code = 0
    var result = ""
    var err = ""
    var fullurl = url
    if (getParam != nil && getParam != "") {
        fullurl += "?\(getParam!)"
    }
    let req = HttpOperations.buildRequest(fullurl, method, mimeType, data, postParam, fileParam)
    let session = URLSession.shared
    let task = (fileParam == nil) ? (
        session.dataTask(with: req) { (data, respond, error) in
            let resp = respond as? HTTPURLResponse
            code = (resp != nil) ? resp!.statusCode : 0
            result = (data != nil) ? String(data: data!, encoding:.utf8)! : ""
            err = error != nil ? "\(error!)" : ""
            semaphore.signal()
    }) : (
        session.uploadTask(with: req, from: nil) { (data, respond, error) in
            let resp = respond as? HTTPURLResponse
            code = (resp != nil) ? resp!.statusCode : 0
            result = (data != nil) ? String(data: data!, encoding:.utf8)! : ""
            err = error != nil ? "\(error!)" : ""
            semaphore.signal()
    })
    task.resume()
    _ = semaphore.wait(timeout: .distantFuture)
    if (callback != nil) {
        callback!(code, result, err)
    }
    return result
}

func blockingHttpGet(_ url: String, _ callback: ((_ code: Int, _ result: String, _ error: String) -> Void)? = nil) -> String {
    return blockingHttp(url, callback)
}

func blockingHttpPost(_ url: String, postParam: Dictionary<String, String>? = nil, _ callback:((_ code: Int, _ result: String, _ error: String) -> Void)? = nil) -> String {
    return blockingHttp(url, postParam: postParam, callback)
}


private class HttpOperations {
    
    static let BOUNDARY_STR = "--"
    static let RANDOM_ID_STR = "_hjreq_"
    
    private class func topString(_ uploadId: String, _ uploadFile: String) -> String {
        var str = "\(BOUNDARY_STR)\(RANDOM_ID_STR)\r\n"
        str += "Content-Disposition: form-data; name=\"\(uploadId)\"; filename=\"\(uploadFile)\"\r\nContent-Type: application/octet-stream\r\n\r\n"
        return str
    }
    
    class func buildRequest(_ url: String, _ method: String, _ mimeType: String, _ data: String, _ param: Dictionary<String, String>?, _ files: Dictionary<String, String>?) -> URLRequest {
        let u = URL(string: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        var request = URLRequest.init(url: u!)
        request.httpMethod = method
        if (data != "") {
            request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
            request.httpBody = data.data(using: .utf8)
        } else {
            if (files == nil && param != nil) {
                var pstr = ""
                for (k, v) in param! {
                    pstr += "\(k)=\(v)&"
                }
                request.httpBody = pstr.data(using: .utf8)
            } else if (files != nil) {
                let data = NSMutableData()
                if (param != nil) {
                    for (k, v) in param! {
                        data.append("\(BOUNDARY_STR)\(RANDOM_ID_STR)\r\n".data(using: .utf8)!)
                        data.append("Content-Disposition:form-data; name=\"\(k)\"\r\n\r\n".data(using: .utf8)!)
                        data.append("\(v)\r\n".data(using: .utf8)!)
                    }
                }
                for (k, v) in files! {
                    let topStr = topString(k, (v as NSString).lastPathComponent)
                    data.append(topStr.data(using: .utf8)!)
                    data.append(NSData(contentsOfFile: v)! as Data)
                    data.append("\r\n".data(using: .utf8)!)
                }
                data.append("\(BOUNDARY_STR)\(RANDOM_ID_STR)\(BOUNDARY_STR)\r\n".data(using: .utf8)!)
                request.httpBody = data as Data
                let strLen = "\(data.length)"
                request.setValue(strLen, forHTTPHeaderField: "Content-Length")
                request.setValue("multipart/form-data; boundary=\(RANDOM_ID_STR)", forHTTPHeaderField: "Content-Type")
            }
        }

        return request
    }
}
