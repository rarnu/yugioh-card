#import <Foundation/Foundation.h>

#define BASE_OCG_URL @"https://api.ourocg.cn/"
#define URL_PACKAGES [BASE_OCG_URL stringByAppendingString:@"Package/list"]
#define URL_PACAKGE_CARD [BASE_OCG_URL stringByAppendingString:@"Package/card/packid/%@"]
#define URL_CARD_IMAGE @"http://p.ocgsoft.cn/%ld.jpg"
#define BASE_YUGIOH_URL @"http://rarnu.7thgen.info/yugioh/"
#define URL_FEEDBACK [BASE_YUGIOH_URL stringByAppendingString:@"feedback.php"]
#define PARAM_FEEDBACK @"id=%@&email=%@&text=%@&appver=%@&osver=%@"

