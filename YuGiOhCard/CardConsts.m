#import "CardConsts.h"

@implementation CardConsts

static NSString * _campDefault = @"OCG、TCG";
static NSString * _commonDefault = @"不限";
static NSString * _monster = @"怪兽";
static NSString * _magic = @"魔法";
static NSString * _trap = @"陷阱";

+(NSArray *) campList {
    return @[_campDefault, @"OCG", @"TCG"];
}

+(NSString *) campDefault {
    return _campDefault;
}

+(NSArray *) cardTypeList {
    return @[_commonDefault,
             @"怪兽", @"通常怪兽", @"效果怪兽", @"同调怪兽", @"融合怪兽", @"仪式怪兽", @"XYZ怪兽",
             @"魔法", @"通常魔法", @"场地魔法", @"速攻魔法", @"装备魔法", @"仪式魔法", @"永续魔法",
             @"陷阱", @"通常陷阱", @"反击陷阱", @"永续陷阱"];
}

+(NSString *) cardTypeDefault {
    return _commonDefault;
}

+(NSString *) cardMonsterDefault {
    return _monster;
}
+(NSString *) cardMagicDefault {
    return _magic;
}
+(NSString *) cardTrapDefault {
    return _trap;
}

+(NSArray *) cardSubTypeList {
    return @[_commonDefault, @"卡通", @"灵魂", @"同盟", @"调整", @"二重", @"反转", @"灵摆"];
}

+(NSString *) cardSubTypeDefault {
    return _commonDefault;
}


@end
