import UIKit

class FileUtils: NSObject {
    
    class func getDocumentPath() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true);
        print("Document Path => \(paths[0])")
        return paths[0] 
    }
    
    class func makeDir(dir: String, basePath path: String) -> String {
        let pathTmp = "\(path)/\(dir)"
        let fmgr = FileManager.default
        
        if (!fmgr.fileExists(atPath: pathTmp)) {
            do {
                try fmgr.createDirectory(atPath: pathTmp, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
            }
        }
        return pathTmp
    }
    
    class func writeTextFile(fileName: String, savePath path: String, fileContent text: String) {
        let document = self.getDocumentPath()
        let pathTmp = self.makeDir(dir: path, basePath:document)
        let fileOper = "\(pathTmp)/\(fileName)"
        let writeData = (text as NSString).data(using: String.Encoding.utf8.rawValue)
        NSData(data: writeData!).write(toFile: fileOper, atomically: true)
    }
    
    class func readTextFile(fileName: String, loadPath path: String) -> String {
        let document = self.getDocumentPath()
        let pathTemp = "\(document)/\(path)"
        let fileOper = "\(pathTemp)/\(fileName)"
    
        var text: String = ""
        if (self.fileExists(fileName: fileName, filePath:path)) {
            let readData = NSData(contentsOfFile: fileOper)
            text = NSString(data: readData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        }
        return text
    }
    
    class func writeFile(fileName: String, savePath path: String, fileData data: NSData) {
        let document = self.getDocumentPath()
        let pathTmp = self.makeDir(dir: path, basePath:document)
        let fileOper = "\(pathTmp)/\(fileName)"
        data.write(toFile: fileOper, atomically:true)
    }
    
    class func readFile(fileName: String, loadPath path: String) -> NSData? {
        let document = self.getDocumentPath()
        let pathTemp = "\(document)/\(path)"
        let fileOper = "\(pathTemp)/\(fileName)"
        var retData: NSData? = nil
        if (self.fileExists(fileName: fileName, filePath:path)) {
            retData = NSData(contentsOfFile: fileOper)
        }
        return retData
    }
    
    class func fileExists(fileName: String, filePath path: String) -> Bool {
        let document = self.getDocumentPath()
        let pathTemp = "\(document)/\(path)"
        let fileOper = "\(pathTemp)/\(fileName)"
        let fmgr = FileManager.default
        return fmgr.fileExists(atPath: fileOper)
    }
    
    class func fileSizeAtPath(filePath: String) -> UInt64 {
        let manager = FileManager.default
        if (manager.fileExists(atPath: filePath)) {
            let attrs = try? manager.attributesOfItem(atPath: filePath)
            if (attrs != nil) {
                return UInt64((attrs![FileAttributeKey.size]! as! NSNumber).int64Value)
            }
            
        }
        return 0
    }
    
    class func folderSizeAtPath(folderPath: String) -> Double {
        let manager = FileManager.default
        if (!manager.fileExists(atPath: folderPath)) {
            return 0
        }
        let childFilesEnumerator = manager.subpaths(atPath: folderPath)
        var folderSize: UInt64 = 0
        if (childFilesEnumerator != nil) {
            for fileName in childFilesEnumerator! {
                let fileAbsolutePath = "\(folderPath)/\(fileName)"
                folderSize += self.fileSizeAtPath(filePath: fileAbsolutePath)
            }
        }
        // Byte to M
        let fz: Double = Double(folderSize)
        return (fz / 1024.0 / 1024.0)
    }
   
}
