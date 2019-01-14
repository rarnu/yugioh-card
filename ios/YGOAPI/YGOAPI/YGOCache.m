//
//  YGOCache.m
//  YGOAPI
//
//  Created by rarnu on 2019/1/14.
//  Copyright © 2019 rarnu. All rights reserved.
//

#import "YGOCache.h"

@implementation YGOCache

+(NSString*) getCachePath {
    NSArray<NSString *>* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
    NSString* p = paths[0];
    p = [[p stringByAppendingPathComponent:@"cache"] stringByAppendingString:@"/"];
    NSFileManager* mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:p]) {
        [mgr createDirectoryAtPath:p withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return p;
}

+(NSString *) loadCache:(NSString *) hashid type:(int) type {
    NSString* ret = nil;
    NSString* path = [[YGOCache getCachePath] stringByAppendingFormat:@"%@_%d.data", hashid, type];
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:path]) {
        ret = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    return ret;
}

+(void) saveCache:(NSString *) hashid type:(int) type text:(NSString*) text {
    NSString* path = [[YGOCache getCachePath] stringByAppendingFormat:@"%@_%d.data", hashid, type];
    [[text dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
}

+(void) cleanCache {
    NSFileManager* mgr = [NSFileManager defaultManager];
    NSString* path = [YGOCache getCachePath];
    NSArray<NSString *>* files = [mgr contentsOfDirectoryAtPath:path error:nil];
    for (int i = 0; i < files.count; i++) {
        NSString* filepath = [path stringByAppendingPathComponent:[files objectAtIndex:i]];
        [mgr removeItemAtPath:filepath error:nil];
    }
}

@end
