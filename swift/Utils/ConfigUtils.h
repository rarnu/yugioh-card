#import <Foundation/Foundation.h>

@interface ConfigUtils : NSObject

+(void) saveBackgroundImage: (NSString *) imgName;
+(NSString *) loadBackgroundImage;

@end
