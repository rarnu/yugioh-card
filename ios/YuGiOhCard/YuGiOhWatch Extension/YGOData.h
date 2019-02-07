//
//  YGOData.h
//  YGOAPI
//
//  Created by rarnu on 2018/6/30.
//  Copyright © 2018 rarnu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageInfo: NSObject
@property NSString* season;
@property NSString* url;
@property NSString* name;
@property NSString* abbr;
@end

@interface LimitInfo: NSObject
@property NSInteger limit;
@property NSString* color;
@property NSString* hashid;
@property NSString* name;
@end

@interface CardPackInfo: NSObject
@property NSString* url;
@property NSString* name;
@property NSString* date;
@property NSString* abbr;
@property NSString* rare;
@end

@interface CardDetail: NSObject
@property NSString* name;
@property NSString* japname;
@property NSString* enname;
@property NSString* cardtype;
@property NSString* password;
@property NSString* limit;
@property NSString* belongs;
@property NSString* rare;
@property NSString* pack;
@property NSString* effect;
@property NSString* race;
@property NSString* element;
@property NSString* level;
@property NSString* atk;
@property NSString* def;
@property NSString* link;
@property NSString* linkarrow;
@property NSArray<CardPackInfo*>* packs;
@property NSString* adjust;
@property NSString* wiki;
@property NSInteger imageId;
@end

@interface CardInfo: NSObject
@property NSInteger cardid;
@property NSString* hashid;
@property NSString* name;
@property NSString* japname;
@property NSString* enname;
@property NSString* cardtype;
@end

@interface SearchResult: NSObject
@property NSArray<CardInfo *>* data;
@property NSInteger page;
@property NSInteger pageCount;
@end

@interface YGOData : NSObject

+(CardDetail*) cardDetail:(NSString*) ahtml;
+(NSArray<LimitInfo*>*) limit:(NSString*) ahtml;
+(NSArray<PackageInfo*>*) packageList:(NSString*) ahtml;
+(SearchResult*) packageDetail:(NSString*) ahtml;

@end
