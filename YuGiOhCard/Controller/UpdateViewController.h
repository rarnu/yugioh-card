#import <UIKit/UIKit.h>
#import "HttpUtils.h"
// TODO: update

@interface UpdateViewController : UIViewController<HttpUtilsDelegate>


@property (strong, nonatomic) IBOutlet UILabel * lblCurrentCount;
@property (strong, nonatomic) IBOutlet UILabel * lblNewCount;
@property (strong, nonatomic) IBOutlet UIButton * btnUpdate;
@property (strong, nonatomic) IBOutlet UIProgressView * procDownload;

-(IBAction)updateClicked:(id)sender;

@end
