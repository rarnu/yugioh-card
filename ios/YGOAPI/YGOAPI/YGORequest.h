//
//  YGORequest.h
//  YGOAPI
//
//  Created by rarnu on 2018/6/30.
//  Copyright © 2018 rarnu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL @"https://www.ourocg.cn"
#define RES_URL @"http://ocg.resource.m2v.cn/%ld.jpg"

@interface YGORequest : NSObject

+(NSString*) search:(NSString*) key page:(NSInteger)page;
+(NSString*) cardDetail:(NSString*) hashid;
+(NSString*) cardWiki:(NSString*) hashid;
+(NSString*) limit;
+(NSString*) packageList;
+(NSString*) packageDetail:(NSString*) url;
+(NSString*) hotest;

@end
