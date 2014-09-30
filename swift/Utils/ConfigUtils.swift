import UIKit

let KEY_BACKGROUND = "background"

class ConfigUtils: NSObject {
    
    class func saveBackgroundImage(imgName: String) {
        var def = NSUserDefaults.standardUserDefaults()
        def.setObject(imgName, forKey: KEY_BACKGROUND)
        def.synchronize()
    }
    
    class func loadBackgroundImage() -> String? {
        var def = NSUserDefaults.standardUserDefaults()
        return def.objectForKey(KEY_BACKGROUND) as? String
    }
}
