#import <UIKit/UIKit.h>

@protocol CoinDelegate <NSObject>

@optional
-(void) doneCoin;

@end

@interface CoinView : UIView

@property (strong, nonatomic) UIToolbar * toolbar;
@property (strong, nonatomic) UIButton * btnRefresh;

@property id<CoinDelegate> delegate;

@end
