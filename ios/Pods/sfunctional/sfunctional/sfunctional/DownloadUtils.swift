//
//  DownloadUtils.swift
//  sfunctional
//
//  Created by rarnu on 26/03/2018.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

public enum DownloadState {
    case Start;
    case Progress;
    case Complete;
    case Error;
}

public func download(_ url: String, _ localFile: String, _ callback:@escaping (_ state: DownloadState, _ position: Int64, _ fileSize: Int64, _ error: String?) -> Void) {
    let d = DownloadOperation(callback)
    d.download(url, localFile)
}

private class DownloadOperation: NSObject, URLSessionDownloadDelegate {
    
    private var callback: (_ state: DownloadState, _ position: Int64, _ fileSize: Int64, _ error: String?) -> Void
    private var saveFilePath = ""
    
    init(_ c:@escaping (_ state: DownloadState, _ position: Int64, _ fileSize: Int64, _ error: String?) -> Void) {
        self.callback = c
    }
    
    func download(_ url: String, _ localFile: String) {
        self.saveFilePath = localFile
        let u = URL(string: url)
        let request = URLRequest(url: u!)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        let task = session.downloadTask(with: request)
        self.callback(DownloadState.Start, 0, 0, nil)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            try FileManager.default.moveItem(atPath: location.path, toPath: self.saveFilePath)
            self.callback(DownloadState.Complete, 0, 0, nil)
        } catch {
            self.callback(DownloadState.Error, 0, 0, error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        self.callback(DownloadState.Progress, totalBytesWritten, totalBytesExpectedToWrite, nil)
    }
    
}
