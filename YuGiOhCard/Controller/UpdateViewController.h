#import <UIKit/UIKit.h>
#import "HttpUtils.h"
#import "ZipUtils.h"

@interface UpdateViewController : UIViewController<HttpUtilsDelegate, ZipUtilsDelegate>

@property (strong, nonatomic) IBOutlet UILabel * lblCurrentCount;
@property (strong, nonatomic) IBOutlet UILabel * lblNewCount;
@property (strong, nonatomic) IBOutlet UIButton * btnUpdate;
@property (strong, nonatomic) IBOutlet UIProgressView * procDownload;
@property (strong, nonatomic) IBOutlet UITextView * tvLog;

-(IBAction)updateClicked:(id)sender;

@end
