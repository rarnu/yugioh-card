#import <UIKit/UIKit.h>
#include "CardItem.h"

@interface CardViewController : UITabBarController

@property (nonatomic) NSInteger cardId;
@property (nonatomic) NSString * cardName;
@property (nonatomic) CardItem * card;

@property (strong, nonatomic) IBOutlet UIBarButtonItem * rightButton;

@end
