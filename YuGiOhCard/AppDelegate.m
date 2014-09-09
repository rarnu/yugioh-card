#import "AppDelegate.h"

#import "ViewController.h"
#import "IIViewDeckController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "DatabaseUtils.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize centerController = _viewController;
@synthesize leftController = _leftController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    IIViewDeckController* deckController = [self generateControllerStack];
    self.leftController = deckController.leftController;
    self.centerController = deckController.centerController;
    
    /* To adjust speed of open/close animations, set either of these two properties. */
    // deckController.openSlideAnimationDuration = 0.15f;
    // deckController.closeSlideAnimationDuration = 0.5f;
    
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    [DatabaseUtils copyDatabaseFile];
    sqlite3 * database = [DatabaseUtils openDatabase:@"yugioh.db"];
    sqlite3_stmt * stmt = [DatabaseUtils queryData:database sql:@"select * from YGODATA where id in (1,2,3,4,5)"];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        char * name = (char *) sqlite3_column_text(stmt, 2);
        NSString * nameStr = [[NSString alloc] initWithUTF8String:name];
        NSLog(nameStr);

    }
    return YES;
}

- (IIViewDeckController*)generateControllerStack {
    LeftViewController* leftController = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    RightViewController* rightController = [[RightViewController alloc] initWithNibName:@"RightViewController" bundle:nil];
    
    UIViewController *centerController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    centerController = [[UINavigationController alloc] initWithRootViewController:centerController];
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController
                                                                                    leftViewController:leftController
                                                                                   rightViewController:rightController];
    deckController.leftSize = 100;
    deckController.rightSize = 100;
    
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    return deckController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
 
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
 
}

- (void)applicationWillTerminate:(UIApplication *)application
{
 
}

@end
