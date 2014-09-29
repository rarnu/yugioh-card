#import "ConfigUtils.h"

#pragma mark - config keys
#define KEY_BACKGROUND @"background"

@implementation ConfigUtils

+(void) saveBackgroundImage:(NSString *)imgName {
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    [def setObject:imgName forKey:KEY_BACKGROUND];
    [def synchronize];
}

+(NSString *) loadBackgroundImage {
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:KEY_BACKGROUND];
}

@end
