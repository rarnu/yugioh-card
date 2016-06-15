import UIKit

let KEY_BACKGROUND = "background"

class ConfigUtils: NSObject {
    
    class func saveBackgroundImage(imgName: String) {
        let def = UserDefaults.standard()
        def.set(imgName, forKey: KEY_BACKGROUND)
        def.synchronize()
    }
    
    class func loadBackgroundImage() -> String? {
        let def = UserDefaults.standard()
        return def.object(forKey: KEY_BACKGROUND) as? String
    }
}
