//
//  YGOData.m
//  YGOAPI
//
//  Created by rarnu on 2018/6/30.
//  Copyright © 2018 rarnu. All rights reserved.
//

#import "YGOData.h"
#import "YGORequest.h"
#import "YGOCAPI.h"

@implementation PackageInfo
@end
@implementation LimitInfo
@end
@implementation CardPackInfo
@end
@implementation CardDetail
@end
@implementation CardInfo
@end
@implementation SearchResult
@end
@implementation HotCard
@end
@implementation HotPack
@end
@implementation Hotest
@end

@implementation YGOData

+(NSString*) replaceChars:(NSString*) str {
    if (str == nil) {
        return @"";
    }
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
    str = [str stringByReplacingOccurrencesOfString:@"　" withString:@""];
    return str;
}

+(SearchResult*) parseSearchResult:(NSString*) jsonString {
    SearchResult* result = [[SearchResult alloc] init];
    @try {
        NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        if ([[json valueForKey:@"result"] intValue] == 0) {
            result.page = [[json valueForKey:@"page"] integerValue];
            result.pageCount = [[json valueForKey:@"pagecount"] integerValue];
            NSArray* jarr = [json valueForKey:@"data"];
            NSMutableArray<CardInfo*>* arr = [NSMutableArray array];
            for (int i = 0; i < jarr.count; i++) {
                id obj = [jarr objectAtIndex:i];
                CardInfo* info = [[CardInfo alloc] init];
                info.cardid = [[obj valueForKey:@"id"] integerValue];
                info.hashid = [obj valueForKey:@"hashid"];
                info.name = [YGOData replaceChars:[obj valueForKey:@"name"]];
                info.japname = [YGOData replaceChars:[obj valueForKey:@"japname"]];
                info.enname = [YGOData replaceChars:[obj valueForKey:@"enname"]];
                info.cardtype = [obj valueForKey:@"cardtype"];
                [arr addObject:info];
            }
            result.data = arr;
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return result;
}

+(SearchResult*) searchCommon:(NSString*) key page:(NSInteger)page {
    NSString* data = [YGORequest search:key page:page];
    NSString* parsed = @"";
    if (![data isEqualToString:@""]) {
        parsed = [NSString stringWithUTF8String:parse([data UTF8String], 0)];
    }
    return [YGOData parseSearchResult:parsed];
}

+(SearchResult*) searchComplex:(NSString*) name japname:(NSString*)japname enname:(NSString*) enname race:(NSString*) race element:(NSString*) element atk:(NSString*) atk def:(NSString*) def level:(NSString*) level pendulum:(NSString*) pendulum link:(NSString*) link linkArrow:(NSString*) linkArrow cardType:(NSString*) cardType cardType2:(NSString*) cardType2 effect:(NSString*) effect page:(NSInteger)page {
    NSString* key = @"";
    if (![name isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(name:%@)", name];
    }
    if (![japname isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(japName:%@)", japname];
    }
    if (![enname isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(enName:%@)", enname];
    }
    if (![race isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(race:%@)", race];
    }
    if (![element isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(element:%@)", element];
    }
    if (![atk isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(atk:%@)", atk];
    }
    if (![def isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(def:%@)", def];
    }
    if (![level isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(level:%@)", level];
    }
    if (![pendulum isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(pendulumL:%@)", pendulum];
    }
    if (![link isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(link:%@)", link];
    }
    if (![linkArrow isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(linkArrow:%@)", linkArrow];
    }
    if (![cardType isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(cardType:%@)", cardType];
    }
    if (![cardType2 isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(cardType:%@)", cardType2];
    }
    if (![effect isEqualToString:@""]) {
        key = [key stringByAppendingFormat:@" +(effect:%@)", effect];
    }
    return [YGOData searchCommon:key page:page];
}

+(CardDetail*) cardDetail:(NSString*) hashid {
    NSString* data = [YGORequest cardDetail:hashid];
    NSString* wikidata = [YGORequest cardWiki:hashid];
    NSString* parsed = @"";
    NSString* adjust = @"";
    if (![data isEqualToString:@""]) {
        parsed = [NSString stringWithUTF8String:parse([data UTF8String], 1)];
        adjust = [NSString stringWithUTF8String:parse([data UTF8String], 2)];
    }
    NSString* wikiparsed = @"";
    if (![wikidata isEqualToString:@""]) {
        wikiparsed = [NSString stringWithUTF8String:parse([wikidata UTF8String], 3)];
    }
    
    CardDetail* result = [[CardDetail alloc] init];
    @try {
        NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:[parsed dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        if ([[json valueForKey:@"result"] intValue] == 0) {
            id obj = [json valueForKey:@"data"];
            result.name = [YGOData replaceChars:[obj valueForKey:@"name"]];
            result.japname = [YGOData replaceChars:[obj valueForKey:@"japname"]];
            result.enname = [YGOData replaceChars:[obj valueForKey:@"enname"]];
            result.cardtype = [obj valueForKey:@"cardtype"];
            result.password = [obj valueForKey:@"password"];
            result.limit = [obj valueForKey:@"limit"];
            result.belongs = [obj valueForKey:@"belongs"];
            result.rare = [obj valueForKey:@"rare"];
            result.pack = [YGOData replaceChars:[obj valueForKey:@"pack"]];
            result.effect = [YGOData replaceChars:[obj valueForKey:@"effect"]];
            result.race = [obj valueForKey:@"race"];
            result.element = [obj valueForKey:@"element"];
            result.level = [obj valueForKey:@"level"];
            result.atk = [obj valueForKey:@"atk"];
            result.def = [obj valueForKey:@"def"];
            result.link = [obj valueForKey:@"link"];
            
            NSMutableArray<CardPackInfo*>* pk = [NSMutableArray array];
            NSArray* jarr = [obj valueForKey:@"packs"];
            for (int i = 0; i < jarr.count; i++) {
                id pkinfo = [jarr objectAtIndex:i];
                CardPackInfo* info = [[CardPackInfo alloc] init];
                info.url = [pkinfo valueForKey:@"url"];
                info.name = [YGOData replaceChars:[pkinfo valueForKey:@"name"]];
                info.date = [pkinfo valueForKey:@"date"];
                info.abbr = [pkinfo valueForKey:@"abbr"];
                info.rare = [pkinfo valueForKey:@"rare"];
                [pk addObject:info];
            }
            result.packs = pk;
            result.adjust = [YGOData replaceChars:adjust];
            result.wiki = [YGOData replaceChars:wikiparsed];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return result;
}

+(NSArray<LimitInfo*>*) limit {
    NSString* data = [YGORequest limit];
    NSString* parsed = @"";
    if (![data isEqualToString:@""]) {
        parsed = [NSString stringWithUTF8String:parse([data UTF8String], 4)];
    }
    NSMutableArray<LimitInfo*>* result = [NSMutableArray array];
    @try {
        NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:[parsed dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        if ([[json valueForKey:@"result"] intValue] == 0) {
            NSArray* jarr = [json valueForKey:@"data"];
            for (int i = 0; i < jarr.count; i++) {
                id obj = [jarr objectAtIndex:i];
                LimitInfo* info = [[LimitInfo alloc] init];
                info.limit = [[obj valueForKey:@"limit"] integerValue];
                info.color = [obj valueForKey:@"color"];
                info.hashid = [obj valueForKey:@"hashid"];
                info.name = [YGOData replaceChars:[obj valueForKey:@"name"]];
                [result addObject:info];
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return result;
}

+(NSArray<PackageInfo*>*) packageList {
    NSString* data = [YGORequest packageList];
    NSString* parsed = @"";
    if (![data isEqualToString:@""]) {
        parsed = [NSString stringWithUTF8String:parse([data UTF8String], 5)];
    }
    NSMutableArray<PackageInfo*>* result = [NSMutableArray array];
    @try {
        NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:[parsed dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        if ([[json valueForKey:@"result"] intValue] == 0) {
            NSArray* jarr = [json valueForKey:@"data"];
            for (int i = 0; i < jarr.count; i++) {
                id obj = [jarr objectAtIndex:i];
                PackageInfo* info = [[PackageInfo alloc] init];
                info.season = [obj valueForKey:@"season"];
                info.url = [obj valueForKey:@"url"];
                info.name = [YGOData replaceChars:[obj valueForKey:@"name"]];
                info.abbr = [obj valueForKey:@"abbr"];
                [result addObject:info];
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return result;
}

+(SearchResult*) packageDetail:(NSString*) url {
    NSString* data = [YGORequest packageDetail:url];
    NSString* parsed = @"";
    if (![data isEqualToString:@""]) {
        parsed = [NSString stringWithUTF8String:parse([data UTF8String], 0)];
    }
    return [YGOData parseSearchResult:parsed];
}

+(Hotest*) hostest {
    NSString* data = [YGORequest hotest];
    NSString* parsed = @"";
    if (![data isEqualToString:@""]) {
        parsed = [NSString stringWithUTF8String:parse([data UTF8String], 6)];
    }
    Hotest* result = [[Hotest alloc] init];
    @try {
        NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:[parsed dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        if ([[json valueForKey:@"result"] intValue] == 0) {
            NSArray* arrSearch = [json valueForKey:@"search"];
            NSMutableArray<NSString*>* retSearch = [NSMutableArray array];
            for (int i = 0; i < arrSearch.count; i++) {
                [retSearch addObject:[arrSearch objectAtIndex:i]];
            }
            NSArray* arrCard = [json valueForKey:@"card"];
            NSMutableArray<HotCard*>* retCard = [NSMutableArray array];
            for (int i = 0; i < arrCard.count; i++) {
                HotCard* ci = [[HotCard alloc] init];
                ci.name = [YGOData replaceChars:[[arrCard objectAtIndex:i] valueForKey:@"name"]];
                ci.hashid = [[arrCard objectAtIndex:i] valueForKey:@"hashid"];
                [retCard addObject:ci];
            }
            NSArray* arrPack = [json valueForKey:@"pack"];
            NSMutableArray<HotPack*>* retPack = [NSMutableArray array];
            for (int i = 0; i < arrPack.count; i++) {
                HotPack* pi = [[HotPack alloc] init];
                pi.name = [YGOData replaceChars:[[arrPack objectAtIndex:i] valueForKey:@"name"]];
                pi.packid = [[arrPack objectAtIndex:i] valueForKey:@"packid"];
                [retPack addObject:pi];
            }
            result.search = retSearch;
            result.card = retCard;
            result.pack = retPack;
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    return result;
}

@end
