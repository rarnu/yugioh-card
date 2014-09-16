#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "CardAttributePicker.h"

@interface SearchViewController : UIViewController<UITextFieldDelegate, CardAttributePickerDelegate>


@property UITextField * currentTv;
@property BOOL keyboardIsShown;
@property (strong, nonatomic) IBOutlet UIScrollView * sv;
@property (strong, nonatomic) IBOutlet UITextField * txtCardName;
@property (strong, nonatomic) IBOutlet UITextField * txtCamp;
@property (strong, nonatomic) IBOutlet UITextField * txtCardType;
@property (strong, nonatomic) IBOutlet UITextField * txtSubtype;

@end
