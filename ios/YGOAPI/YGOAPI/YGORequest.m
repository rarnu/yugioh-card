//
//  YGORequest.m
//  YGOAPI
//
//  Created by rarnu on 2018/6/30.
//  Copyright © 2018 rarnu. All rights reserved.
//

#import "YGORequest.h"

@implementation YGORequest

#define BASE_URL @"https://www.ourocg.cn"

+(NSString*) request:(NSString*) url {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * u = [NSURL URLWithString:url];
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:u cachePolicy:0 timeoutInterval:2.0f];
    NSHTTPURLResponse * resp;
    NSData * retData =[NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:nil];
    NSString* ret = @"";
    if (resp.statusCode == 200) {
        ret = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
    }
    return ret;
}

+(NSString*) search:(NSString*) key page:(NSInteger)page {
    NSString* urlStr =[BASE_URL stringByAppendingFormat:@"/search/%@/%ld", key, page];
    return [YGORequest request:urlStr];
}

+(NSString*) cardDetail:(NSString*) hashid {
    NSString* urlStr = [BASE_URL stringByAppendingFormat:@"/card/%@", hashid];
    return [YGORequest request:urlStr];
}

+(NSString*) cardWiki:(NSString*) hashid {
    NSString* urlStr = [BASE_URL stringByAppendingFormat:@"/card/%@/wiki", hashid];
    return [YGORequest request:urlStr];
}

+(NSString*) limit {
    NSString* urlStr = [BASE_URL stringByAppendingString:@"/Limit-Latest"];
    return [YGORequest request:urlStr];
}

+(NSString*) packageList {
    NSString* urlStr = [BASE_URL stringByAppendingString:@"/package"];
    return [YGORequest request:urlStr];
}

+(NSString*) packageDetail:(NSString*) url {
    NSString* urlStr = [BASE_URL stringByAppendingString:url];
    return [YGORequest request:urlStr];
}

@end
