#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "CardAttributePicker.h"

@interface SearchViewController : UIViewController<UITextFieldDelegate, CardAttributePickerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView * sv;
@property (strong, nonatomic) IBOutlet UITextField * txtCardName;
@property (strong, nonatomic) IBOutlet UITextField * txtCamp;
@property (strong, nonatomic) IBOutlet UITextField * txtCardType;
@property (strong, nonatomic) IBOutlet UITextField * txtSubtype;
@property (strong, nonatomic) IBOutlet UITextField * txtRace;
@property (strong, nonatomic) IBOutlet UITextField * txtAttribute;
@property (strong, nonatomic) IBOutlet UITextField * txtLevel;
@property (strong, nonatomic) IBOutlet UITextField * txtRare;
@property (strong, nonatomic) IBOutlet UITextField * txtLimit;
@property (strong, nonatomic) IBOutlet UITextField * txtAtk;
@property (strong, nonatomic) IBOutlet UITextField * txtDef;
@property (strong, nonatomic) IBOutlet UITextField * txtEffect;

@property (nonatomic) NSString * pushView;

@end
