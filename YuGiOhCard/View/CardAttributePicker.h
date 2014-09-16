#import <UIKit/UIKit.h>

@protocol CardAttributePickerDelegate <NSObject>

@optional
-(void) pickDone: (NSString *) picked textField: (UITextField *) textField;

@end

@interface CardAttributePicker : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView * picker;
@property (strong, nonatomic) UIView * toolbar;
@property (strong, nonatomic) UITextField * txtResult;
@property (nonatomic) NSArray * pickObjects;
@property id<CardAttributePickerDelegate> delegate;

-(void) setTitle: (NSString *) title;
-(void) selectFirst;
-(void) selectCurrent: (NSString *) text;

@end
