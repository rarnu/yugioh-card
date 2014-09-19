#import <UIKit/UIKit.h>
#import "HttpUtils.h"

@interface PackDetailViewController : UITableViewController<HttpUtilsDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem * refreshButton;
@property (nonatomic) NSString * packageId;

@end
