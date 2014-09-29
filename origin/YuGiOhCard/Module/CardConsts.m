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
             _monster, CT_MONSTER_NORMAL, CT_MONSTER_EFFECT, CT_MONSTER_SYNCHRO, CT_MONSTER_FUSION, CT_MONSTER_RITUAL, CT_MONSTER_XYZ,
             _magic, CT_MAGIC_NORMAL, CT_MAGIC_FIELD, CT_MAGIC_SPEED, CT_MAGIC_EQUIP, CT_MAGIC_RITUAL, CT_MAGIC_CONTINIOUS,
             _trap, CT_TRAP_NORMAL, CT_TRAP_COUNTER, CT_TRAP_CONTINIOUS];
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

+(NSArray *) cardRaceList {
    return @[_commonDefault, RACE_WARRIOR, RACE_UNDEAD, RACE_DEMON, RACE_BEAST, RACE_BEAST_WARRIOR, RACE_DINOSAUR, RACE_FISH, RACE_MACHINE, RACE_WATER, RACE_ANGEL, RACE_MAGICIAN, RACE_FIRE, RACE_THUNDER, RACE_LIZARD, RACE_PLANT, RACE_INSECT, RACE_STONE, RACE_SEA_DRAGON, RACE_BIRD, RACE_DRAGON, RACE_MENTAL, RACE_DREAM_DRAGON, RACE_GOD];
}
+(NSString *) cardRaceDefault {
    return _commonDefault;
}

+(NSArray *) cardAttributeList {
    return @[_commonDefault, ATTR_EARTH, ATTR_WATER, ATTR_FIRE, ATTR_WIND, ATTR_LIGHT, ATTR_DARK, ATTR_GOD];
}

+(NSString *) cardAttributeDefault {
    return _commonDefault;
}

+(NSArray *) cardLevelList {
    return @[_commonDefault, @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
}

+(NSString *) cardLevelDefault {
    return _commonDefault;
}

+(NSArray *) cardRareList {
    return @[_commonDefault, RARE_N, RARE_R, RARE_GR, RARE_NR, RARE_SR, RARE_UR, RARE_PR, RARE_HR, RARE_GHR, RARE_NPR, RARE_RUR, RARE_SCR, RARE_SER, RARE_USR, RARE_UTR];
}

+(NSString *) cardRareDefault {
    return _commonDefault;
}

+(NSArray *) cardLimitList {
    return @[_commonDefault, LIMIT_NONE, LIMIT_BAN, LIMIT_LIMIT, LIMIT_LIMIT_2, LIMIT_SHOWN];
}

+(NSString *) cardLimitDefault {
    return _commonDefault;
}

@end
