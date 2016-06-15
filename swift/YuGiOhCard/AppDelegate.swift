import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIUtils.setStatusBar(light: true)
        UIUtils.getWidthDelta()
        UIUtils.setTextFieldCursorColor(color: UIColor.white())
        let _ = DatabaseUtils.copyDatabaseFile()
        let _ = DatabaseUtils.openDatabase()
        DatabaseUtils.updateDatabase()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DatabaseUtils.closeDatabase()
    }
}

