//
//  YGORequest.h
//  YGOAPI
//
//  Created by rarnu on 2018/6/30.
//  Copyright © 2018 rarnu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGORequest : NSObject

+(NSString*) search:(NSString*) key page:(NSInteger)page;
+(NSString*) cardDetail:(NSString*) hashid;
+(NSString*) cardWiki:(NSString*) hashid;
+(NSString*) limit;
+(NSString*) packageList;
+(NSString*) packageDetail:(NSString*) url;

@end
