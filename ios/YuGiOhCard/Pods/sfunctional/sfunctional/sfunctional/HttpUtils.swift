//
//  HttpUtils.swift
//  sfunctional
//
//  Created by rarnu on 26/03/2018.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

public func http(_ url: String, method: String = "GET", getParam: String? = nil, postParam: Dictionary<String, String>? = nil, fileParam: Dictionary<String, String>? = nil, _ callback:@escaping (_ code: Int, _ result: String?, _ error: String?) -> Void) {
    var fullurl = url
    if (getParam != nil && getParam != "") {
        fullurl += "?\(getParam!)"
    }
    let req = HttpOperations.buildRequest(fullurl, method, postParam, fileParam)
    let session = URLSession.shared
    let task = (fileParam == nil) ? (
        session.dataTask(with: req) { (data, respond, error) in
            let resp = respond as? HTTPURLResponse
            let code = (resp != nil) ? resp!.statusCode : 0
            let result = (data != nil) ? String(data: data!, encoding:.utf8) : ""
            callback(code, result, nil)
        }) :(
        session.uploadTask(with: req, from: nil) { (data, respond, error) in
            let resp = respond as? HTTPURLResponse
            let code = (resp != nil) ? resp!.statusCode : 0
            let result = (data != nil) ? String(data: data!, encoding:.utf8) : ""
            callback(code, result, nil)
        })
    task.resume()
}

private class HttpOperations {
    
    static let BOUNDARY_STR = "--"
    static let RANDOM_ID_STR = "_hjreq_"
    
    private class func topString(_ uploadId: String, _ uploadFile: String) -> String {
        var str = "\(BOUNDARY_STR)\(RANDOM_ID_STR)\n"
        str += "Content-Disposition: form-data; name=\"\(uploadId)\"; filename=\"\(uploadFile)\"\r\n"
        str += "Content-Type: */*\r\n\r\n"
        return str
    }
    
    class func buildRequest(_ url: String, _ method: String, _ param: Dictionary<String, String>?, _ files: Dictionary<String, String>?) -> URLRequest {
        let u = URL(string: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        var request = URLRequest.init(url: u!)
        request.httpMethod = method
        if (files == nil && param != nil) {
            var pstr = ""
            for (k, v) in param! {
                pstr += "\(k)=\(v)&"
            }
            request.httpBody = pstr.data(using: .utf8)
        } else if (files != nil) {
            let data = NSMutableData()
            if (param != nil) {
                for (k, _) in param! {
                    data.append("\(BOUNDARY_STR)\(RANDOM_ID_STR)\r\n".data(using: .utf8)!)
                    data.append("Content-Disposition:form-data; name=\"\(k)\"\r\n\r\n".data(using: .utf8)!)
                    data.append("\(k)\r\n".data(using: .utf8)!)
                }
            }
            for (k, v) in files! {
                let topStr = topString(k, (v as NSString).lastPathComponent)
                data.append(topStr.data(using: .utf8)!)
                data.append((NSData(contentsOfFile: v) as Data?)!)
                data.append("\(v)\r\n".data(using: .utf8)!)
            }
            data.append("\(BOUNDARY_STR)\(RANDOM_ID_STR)--\n".data(using: .utf8)!)
            request.httpBody = data as Data
            let strLen = "\(data.length)"
            request.setValue(strLen, forHTTPHeaderField: "Content-Length")
        }
        return request
    }
}
