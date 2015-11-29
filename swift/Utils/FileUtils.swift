import UIKit

class FileUtils: NSObject {
    
    class func getDocumentPath() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true);
        return paths[0] 
    }
    
    class func makeDir(dir: String, basePath path: String) -> String {
        let pathTmp = "\(path)/\(dir)"
        let fmgr = NSFileManager.defaultManager()
        
        if (!fmgr.fileExistsAtPath(pathTmp)) {
            do {
                try fmgr.createDirectoryAtPath(pathTmp, withIntermediateDirectories:true, attributes:nil)
            } catch _ {
            }
        }
        return pathTmp
    }
    
    class func writeTextFile(fileName: String, savePath path: String, fileContent text: String) {
        let document = self.getDocumentPath()
        let pathTmp = self.makeDir(path, basePath:document)
        let fileOper = "\(pathTmp)/\(fileName)"
        let writeData = (text as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        writeData!.writeToFile(fileOper, atomically:true)
    }
    
    class func readTextFile(fileName: String, loadPath path: String) -> String {
        let document = self.getDocumentPath()
        let pathTemp = "\(document)/\(path)"
        let fileOper = "\(pathTemp)/\(fileName)"
    
        var text: String = ""
        if (self.fileExists(fileName, filePath:path)) {
            let readData = NSData(contentsOfFile: fileOper)
            text = NSString(data: readData!, encoding: NSUTF8StringEncoding) as! String
        }
        return text
    }
    
    class func writeFile(fileName: String, savePath path: String, fileData data: NSData) {
        let document = self.getDocumentPath()
        let pathTmp = self.makeDir(path, basePath:document)
        let fileOper = "\(pathTmp)/\(fileName)"
        data.writeToFile(fileOper, atomically:true)
    }
    
    class func readFile(fileName: String, loadPath path: String) -> NSData? {
        let document = self.getDocumentPath()
        let pathTemp = "\(document)/\(path)"
        let fileOper = "\(pathTemp)/\(fileName)"
        var retData: NSData? = nil
        if (self.fileExists(fileName, filePath:path)) {
            retData = NSData(contentsOfFile: fileOper)
        }
        return retData
    }
    
    class func fileExists(fileName: String, filePath path: String) -> Bool {
        let document = self.getDocumentPath()
        let pathTemp = "\(document)/\(path)"
        let fileOper = "\(pathTemp)/\(fileName)"
        let fmgr = NSFileManager.defaultManager()
        return fmgr.fileExistsAtPath(fileOper)
    }
    
    class func fileSizeAtPath(filePath: String) -> UInt64 {
        let manager = NSFileManager.defaultManager()
        if (manager.fileExistsAtPath(filePath)) {
            let attrs = try? manager.attributesOfItemAtPath(filePath)
            let dic = NSDictionary(dictionary: attrs!)
            return dic.fileSize()
        }
        return 0
    }
    
    class func folderSizeAtPath(folderPath: String) -> Double {
        let manager = NSFileManager.defaultManager()
        if (!manager.fileExistsAtPath(folderPath)) {
            return 0
        }
        let childFilesEnumerator = manager.subpathsAtPath(folderPath)
        var folderSize: UInt64 = 0
        if (childFilesEnumerator != nil) {
            for fileName in childFilesEnumerator! {
                let fileAbsolutePath = "\(folderPath)/\(fileName)"
                folderSize += self.fileSizeAtPath(fileAbsolutePath)
            }
        }
        // Byte to M
        let fz: Double = Double(folderSize)
        return (fz / 1024.0 / 1024.0)
    }
   
}
