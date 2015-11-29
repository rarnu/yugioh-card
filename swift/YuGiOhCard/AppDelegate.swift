import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIUtils.setStatusBar(true)
        UIUtils.getWidthDelta()
        UIUtils.setTextFieldCursorColor(UIColor.whiteColor())
        DatabaseUtils.copyDatabaseFile()
        DatabaseUtils.openDatabase()
        DatabaseUtils.updateDatabase()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        DatabaseUtils.closeDatabase()
    }
}

