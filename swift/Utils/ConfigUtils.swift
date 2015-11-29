import UIKit

let KEY_BACKGROUND = "background"

class ConfigUtils: NSObject {
    
    class func saveBackgroundImage(imgName: String) {
        let def = NSUserDefaults.standardUserDefaults()
        def.setObject(imgName, forKey: KEY_BACKGROUND)
        def.synchronize()
    }
    
    class func loadBackgroundImage() -> String? {
        let def = NSUserDefaults.standardUserDefaults()
        return def.objectForKey(KEY_BACKGROUND) as? String
    }
}
