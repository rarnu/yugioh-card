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

@interface HotCard: NSObject
@property NSString* hashid;
@property NSString* name;
@end

@interface HotPack: NSObject
@property NSString* packid;
@property NSString* name;
@end

@interface Hotest: NSObject
@property NSArray<NSString*>* search;
@property NSArray<HotCard*>* card;
@property NSArray<HotPack*>* pack;
@end

@interface YGOData : NSObject

+(SearchResult*) searchCommon:(NSString*) key page:(NSInteger)page;
+(SearchResult*) searchComplex:(NSString*) name japname:(NSString*)japname enname:(NSString*) enname race:(NSString*) race element:(NSString*) element atk:(NSString*) atk def:(NSString*) def level:(NSString*) level pendulum:(NSString*) pendulum link:(NSString*) link linkArrow:(NSString*) linkArrow cardType:(NSString*) cardType cardType2:(NSString*) cardType2 effect:(NSString*) effect page:(NSInteger)page;
+(CardDetail*) cardDetail:(NSString*) hashid;
+(NSArray<LimitInfo*>*) limit;
+(NSArray<PackageInfo*>*) packageList;
+(SearchResult*) packageDetail:(NSString*) url;
+(Hotest*) hostest;

@end
