import UIKit

class ApplicationUtils: NSObject {
 
    
    class func getAppName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }
    
    class func getAppVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    class func getAppBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
    
    class func getScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    class func getApplicationSize() -> CGSize {
        return UIScreen.main.applicationFrame.size
    }
    
    class func getPublicDate() -> String {
        let obj = Bundle.main.object(forInfoDictionaryKey: "PublicDate")
        var str = ""
        if (obj != nil) {
            str = obj! as! String
        }
        return str
    }

}