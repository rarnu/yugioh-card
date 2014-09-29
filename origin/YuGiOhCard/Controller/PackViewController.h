#import <UIKit/UIKit.h>
#import "HttpUtils.h"

@interface PackViewController : UITableViewController<HttpUtilsDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem * refreshButton;

@end
