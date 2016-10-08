import UIKit

@objc protocol ZipUtilsDelegate: NSObjectProtocol {
    @objc optional func zipWillUnzip() -> Bool
    @objc optional func ziputils(ziputils: ZipUtils, unzipCompleted succ: Bool)

}

class ZipUtils: NSObject {
    var delegate: ZipUtilsDelegate?
    var archiveFile: String?
    var extractPath: String?
    
    func unzip() {
        Thread.detachNewThreadSelector(#selector(doUncompress), toTarget: self, with: nil)
    }
    
    func doUncompress() {
        var b = false
        if (self.delegate?.zipWillUnzip != nil) {
            b = self.delegate!.zipWillUnzip!()
        }
        if (b) {
            let za = ZipArchive()
            var ret = NSNumber(value: false)
            if (za.unzipOpenFile(self.archiveFile!)) {
                let succ = za.unzipFile(to: self.extractPath, overWrite:true)
                za.unzipCloseFile()
                ret = NSNumber(value: succ)
            }
            DispatchQueue.main.async(execute: {
                self.callback(ret: ret)
            })
        }
    }
    
    func callback(ret: NSNumber) {
        self.delegate?.ziputils?(ziputils: self, unzipCompleted: ret.boolValue)
    }

}
