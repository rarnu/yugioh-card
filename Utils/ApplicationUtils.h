#import <Foundation/Foundation.h>

@interface ApplicationUtils : NSObject

+(NSString *) getAppName;
+(NSString *) getAppVersion;
+(NSString *) getAppBuild;
+(CGSize) getScreenSize;
+(CGSize) getApplicationSize;

@end

