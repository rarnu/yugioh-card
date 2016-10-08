//
//  HttpUtils.swift
//  YuGiOhCard
//
//  Created by rarnu on 9/30/14.
//  Copyright (c) 2014 rarnu. All rights reserved.
//

import UIKit

@objc protocol HttpUtilsDelegate: NSObjectProtocol {
    @objc optional func httpUtils(httpUtils:HttpUtils, receivedData data: NSData?)
    @objc optional func httpUtils(httpUtils:HttpUtils, receivedError err: String)
    @objc optional func httpUtils(httpUtils:HttpUtils, receivedFileSize fileSize: Int64)
    @objc optional func httpUtils(httpUtils:HttpUtils, receivedProgress progress: Int)
}

class HttpUtils: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    var receivedData: NSMutableData?
    var delegate: HttpUtilsDelegate?
    var tag: Int?
    
    func get(url: String) {
        let u = NSURL(string: url)
        let req = URLRequest(url: u! as URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 60)
        let conn = NSURLConnection(request: req as URLRequest, delegate: self)
        conn!.start()
    }
    
    func post(url: String, param: String) {
        let u = NSURL(string: url)
        let req = NSMutableURLRequest(url: u! as URL)
        req.httpMethod = "POST"
        req.timeoutInterval = 60
        let data = (param as NSString).data(using: String.Encoding.utf8.rawValue)
        req.httpBody = data
        let conn = NSURLConnection(request: req as URLRequest, delegate: self)
        conn!.start()
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        self.receivedData!.append(data)
        self.delegate?.httpUtils?(httpUtils: self, receivedProgress: self.receivedData!.length)
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        self.receivedData = NSMutableData()
        self.delegate?.httpUtils?(httpUtils: self, receivedFileSize: response.expectedContentLength)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        self.delegate?.httpUtils?(httpUtils: self, receivedData: self.receivedData)
    }
    
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        NSLog(error.localizedDescription)
        self.delegate?.httpUtils?(httpUtils: self, receivedError: error.localizedDescription)
    }
    
    
    
    func connection(_ connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: URLProtectionSpace) -> Bool {
        return protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
    }
    
    func connection(_ connection: NSURLConnection, didReceive challenge: URLAuthenticationChallenge) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            challenge.sender!.use(URLCredential(trust: challenge.protectionSpace.serverTrust!), for: challenge)
        }
        challenge.sender!.continueWithoutCredential(for: challenge)
    }
    
}
