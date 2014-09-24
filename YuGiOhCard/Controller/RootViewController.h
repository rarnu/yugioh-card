#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface RootViewController : RESideMenu <RESideMenuDelegate>

+(RootViewController *) getInstance;

@end
