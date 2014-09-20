#import <UIKit/UIKit.h>


@protocol DiceDelegate <NSObject>

@optional
-(void) doneDice;

@end

@interface DiceView : UIView

@property (strong, nonatomic) UIImageView * imgDice;

@property id<DiceDelegate> delegate;

@end
