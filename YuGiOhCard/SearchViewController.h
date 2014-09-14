#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface SearchViewController : UIViewController<UITextFieldDelegate>


@property UITextField * currentTv;
@property BOOL keyboardIsShown;
@property (strong, nonatomic) IBOutlet UIScrollView * sv;
@property (strong, nonatomic) IBOutlet UITextField * txtCardName;

@end
