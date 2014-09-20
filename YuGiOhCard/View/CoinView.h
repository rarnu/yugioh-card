#import <UIKit/UIKit.h>

@protocol CoinDelegate <NSObject>

@optional
-(void) doneCoin;

@end

@interface CoinView : UIView

@property (strong, nonatomic) UIImageView * imgCoin;

@property id<CoinDelegate> delegate;

@end
