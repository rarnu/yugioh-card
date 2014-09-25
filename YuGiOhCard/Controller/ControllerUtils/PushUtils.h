#import <Foundation/Foundation.h>
#import "CardItem.h"


@interface PushUtils : NSObject

+(void) pushCard: (CardItem *) item navController: (UINavigationController *) nav;

@end
