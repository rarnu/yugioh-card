#import <Foundation/Foundation.h>

#define BASE_OCG_URL @"https://api.ourocg.cn/"
#define URL_PACKAGES [BASE_OCG_URL stringByAppendingString:@"Packages/list"]
#define URL_PACAKGE_CARD [BASE_OCG_URL stringByAppendingString:@"Package/card/packid/%s"]
#define URL_CARD_IMAGE @"http://p.ocgsoft.cn/%ld.jpg"

@interface UrlConsts : NSObject

@end
