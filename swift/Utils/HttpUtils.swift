//
//  HttpUtils.swift
//  YuGiOhCard
//
//  Created by rarnu on 9/30/14.
//  Copyright (c) 2014 rarnu. All rights reserved.
//

import UIKit

@objc
protocol HttpUtilsDelegate: NSObjectProtocol {
    optional func httpUtils(httpUtils:HttpUtils, receivedData data: NSData?)
    optional func httpUtils(httpUtils:HttpUtils, receivedError err: NSString)
    optional func httpUtils(httpUtils:HttpUtils, receivedFileSize fileSize: Int64)
    optional func httpUtils(httpUtils:HttpUtils, receivedProgress progress: Int)
}

class HttpUtils: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    var receivedData: NSMutableData?
    var delegate: HttpUtilsDelegate?
    var tag: Int?
    
    func get(url: String) {
        let u = NSURL(string: url)
        
        let req = NSURLRequest(URL: u!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60)
        let conn = NSURLConnection(request: req, delegate: self)
        conn!.start()
    }
    
    func post(url: String, param: String) {
        let u = NSURL(string: url)
        let req = NSMutableURLRequest(URL: u!)
        req.HTTPMethod = "POST"
        req.timeoutInterval = 60
        let data = (param as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        req.HTTPBody = data
        let conn = NSURLConnection(request: req, delegate: self)
        conn!.start()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.receivedData!.appendData(data)
        self.delegate?.httpUtils?(self, receivedProgress: self.receivedData!.length)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        self.receivedData = NSMutableData()
        self.delegate?.httpUtils?(self, receivedFileSize: response.expectedContentLength)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        self.delegate?.httpUtils?(self, receivedData: self.receivedData)
    }
    
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        NSLog(error.localizedDescription)
        self.delegate?.httpUtils?(self, receivedError: error.localizedDescription)
    }
    
    func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: NSURLProtectionSpace) -> Bool {
        return protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
    }
    
    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            challenge.sender!.useCredential(NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!), forAuthenticationChallenge: challenge)
        }
        challenge.sender!.continueWithoutCredentialForAuthenticationChallenge(challenge)
    }
    
}
