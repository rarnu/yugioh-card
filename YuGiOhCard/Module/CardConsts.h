#import <Foundation/Foundation.h>

#define _campDefault @"OCG、TCG"
#define _commonDefault @"不限"
#define _monster @"怪兽"
#define _magic @"魔法"
#define _trap @"陷阱"

@interface CardConsts : NSObject

+(NSArray *) campList;
+(NSString *) campDefault;

+(NSArray *) cardTypeList;
+(NSString *) cardTypeDefault;
+(NSString *) cardMonsterDefault;
+(NSString *) cardMagicDefault;
+(NSString *) cardTrapDefault;

+(NSArray *) cardSubTypeList;
+(NSString *) cardSubTypeDefault;



@end
