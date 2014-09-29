#import <UIKit/UIKit.h>
#import "HttpUtils.h"

@interface CardPicViewController : UIViewController<HttpUtilsDelegate>

@property (strong, nonatomic) IBOutlet UIImageView * imgCard;
@property (strong, nonatomic) IBOutlet UIButton * btnDownload;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * aivDownload;

@end
