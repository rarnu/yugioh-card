#import "ApplicationUtils.h"

@implementation ApplicationUtils

+(NSString *) getAppName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+(NSString *) getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(NSString *) getAppBuild {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+(CGSize) getScreenSize {
    return [UIScreen mainScreen].bounds.size;
}

+(CGSize) getApplicationSize {
    return [UIScreen mainScreen].applicationFrame.size;
}

+(NSString *) getPublicDate {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"PublicDate"];
}

@end
