import UIKit

class ApplicationUtils: NSObject {
 
    
    class func getAppName() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as String
    }
    
    class func getAppVersion() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as String
    }
    
    class func getAppBuild() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as String
    }
    
    class func getScreenSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    class func getApplicationSize() -> CGSize {
        return UIScreen.mainScreen().applicationFrame.size
    }
    
    class func getPublicDate() -> String {
        var obj: AnyObject? = NSBundle.mainBundle().objectForInfoDictionaryKey("PublicDate")
        var str = ""
        if (obj != nil) {
            str = obj! as String
        }
        return str
    }

}
