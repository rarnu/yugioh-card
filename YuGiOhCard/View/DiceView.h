#import <UIKit/UIKit.h>

@protocol DiceDelegate <NSObject>

@optional
-(void) doneDice;

@end

@interface DiceView : UIView

@property (strong, nonatomic) UIToolbar * toolbar;
@property (strong, nonatomic) UIButton * btnRefresh;

@property id<DiceDelegate> delegate;

@end
