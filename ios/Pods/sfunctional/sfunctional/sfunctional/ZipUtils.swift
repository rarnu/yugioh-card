//
//  ZipUtils.swift
//  sfunctional
//
//  Created by rarnu on 26/03/2018.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit


public func zip(_ zipPath: String, _ src: String, _ callback: @escaping (_ succ: Bool) -> Void) {
    let ret = SSZipArchive.createZipFile(atPath: zipPath, withContentsOfDirectory: src)
    callback(ret)
}

public func unzip(_ zipPath: String, _ dest: String, _  callback: @escaping (_ succ: Bool) -> Void) {
    let ret = SSZipArchive.unzipFile(atPath: zipPath, toDestination: dest)
    callback(ret)
}

