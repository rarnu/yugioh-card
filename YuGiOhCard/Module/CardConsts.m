#import "CardConsts.h"
#import "StringConsts.h"

@implementation CardConsts

+(NSArray *) campList {
    return @[_campDefault, CAMP_OCG, CAMP_TCG];
}

+(NSString *) campDefault {
    return _campDefault;
}

+(NSArray *) cardTypeList {
    return @[_commonDefault,
             _monster, @"通常怪兽", @"效果怪兽", @"同调怪兽", @"融合怪兽", @"仪式怪兽", @"XYZ怪兽",
             _magic, @"通常魔法", @"场地魔法", @"速攻魔法", @"装备魔法", @"仪式魔法", @"永续魔法",
             _trap, @"通常陷阱", @"反击陷阱", @"永续陷阱"];
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
    return @[_commonDefault, MONSTER_TOON, MONSTER_SPIRIT, MONSTER_UNION, MONSTER_TUNNER, MONSTER_DOUBLE, MONSTER_REVERSE, MONSTER_PENDULUM];
}

+(NSString *) cardSubTypeDefault {
    return _commonDefault;
}


@end
