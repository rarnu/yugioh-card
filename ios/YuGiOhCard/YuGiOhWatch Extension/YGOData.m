//
//  YGOData.m
//  YGOAPI
//
//  Created by rarnu on 2018/6/30.
//  Copyright © 2018 rarnu. All rights reserved.
//

#import "YGOData.h"
#import "YGOCAPI.h"

@implementation PackageInfo

-(id) init {
    self = [super init];
    if (self) {
        self.season = @"";
        self.url = @"";
        self.name = @"";
        self.abbr = @"";
    }
    return self;
}

@end

@implementation LimitInfo

-(id) init {
    self = [super init];
    if (self) {
        self.limit = 0;
        self.color = @"";
        self.hashid = @"";
        self.name = @"";
    }
    return self;
}

@end

@implementation CardPackInfo

-(id) init {
    self = [super init];
    if (self) {
        self.url = @"";
        self.name = @"";
        self.date = @"";
        self.abbr = @"";
        self.rare = @"";
    }
    return self;
}

@end

@implementation CardDetail

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"";
        self.japname = @"";
        self.enname = @"";
        self.cardtype = @"";
        self.password = @"";
        self.limit = @"";
        self.belongs = @"";
        self.rare = @"";
        self.pack = @"";
        self.effect = @"";
        self.race = @"";
        self.element = @"";
        self.level = @"";
        self.atk = @"";
        self.def = @"";
        self.link = @"";
        self.linkarrow = @"";
        self.packs = nil;
        self.adjust = @"";
        self.wiki = @"";
        self.imageId = -1;
    }
    return self;
}

@end

@implementation CardInfo

-(id) init {
    self = [super init];
    if (self) {
        self.cardid = 0;
        self.hashid = @"";
        self.name = @"";
        self.japname = @"";
        self.enname = @"";
        self.cardtype = @"";
    }
    return self;
}

@end

@implementation SearchResult

-(id) init {
    self = [super init];
    if (self) {
        self.data = nil;
        self.page = 0;
        self.pageCount = 0;
    }
    return self;
}

@end

@implementation YGOData

+(NSString*) replaceChars:(NSString*) str {
    if (str == nil) {
        return @"";
    }
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str = [str stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"　" withString:@""];
    return str;
}

+(NSString*) replaceLinkArrow:(NSString*) str {
    if (str == nil) {
        return @"";
    }
    str = [str stringByReplacingOccurrencesOfString:@"1" withString:@"↙"];
    str = [str stringByReplacingOccurrencesOfString:@"2" withString:@"↓"];
    str = [str stringByReplacingOccurrencesOfString:@"3" withString:@"↘"];
    str = [str stringByReplacingOccurrencesOfString:@"4" withString:@"←"];
    str = [str stringByReplacingOccurrencesOfString:@"6" withString:@"→"];
    str = [str stringByReplacingOccurrencesOfString:@"7" withString:@"↖"];
    str = [str stringByReplacingOccurrencesOfString:@"8" withString:@"↑"];
    str = [str stringByReplacingOccurrencesOfString:@"9" withString:@"↗"];
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

+(CardDetail*) cardDetail:(NSString*) ahtml {
    
    NSString* parsed = [NSString stringWithUTF8String:parse([ahtml UTF8String], 1)];
    NSString* adjust = [NSString stringWithUTF8String:parse([ahtml UTF8String], 2)];
    
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
            result.linkarrow = [YGOData replaceLinkArrow:[obj valueForKey:@"linkarrow"]];
            
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
            result.wiki = @"";
            result.imageId = [[obj valueForKey:@"imageid"] integerValue];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return result;
}

+(NSArray<LimitInfo*>*) limit:(NSString*) ahtml {
    NSString* parsed = [NSString stringWithUTF8String:parse([ahtml UTF8String], 4)];
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

+(NSArray<PackageInfo*>*) packageList:(NSString*) ahtml {
    NSString* parsed = [NSString stringWithUTF8String:parse([ahtml UTF8String], 5)];
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

+(SearchResult*) packageDetail:(NSString*) ahtml {
    NSString* parsed = [NSString stringWithUTF8String:parse([ahtml UTF8String], 0)];
    return [YGOData parseSearchResult:parsed];
}

@end
