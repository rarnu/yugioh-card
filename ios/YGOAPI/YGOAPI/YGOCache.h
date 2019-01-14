//
//  YGOCache.h
//  YGOAPI
//
//  Created by rarnu on 2019/1/14.
//  Copyright © 2019 rarnu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGOCache : NSObject

// type: 0: detail, 1: wiki
+(NSString *) loadCache:(NSString *) hashid type:(int) type;
+(void) saveCache:(NSString *) hashid type:(int) type text:(NSString*) text;
+(void) cleanCache;

@end
