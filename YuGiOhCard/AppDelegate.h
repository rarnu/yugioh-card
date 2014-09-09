#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class ViewController;
@class IIViewDeckController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) UIViewController *centerController;
@property (retain, nonatomic) UIViewController *leftController;

- (IIViewDeckController*)generateControllerStack;

@end
