#import <Foundation/Foundation.h>

@interface CardItem : NSObject

@property (nonatomic) NSInteger card_id;    // id
@property (nonatomic) NSString * japName;   // japName
@property (nonatomic) NSString * name;      // name
@property (nonatomic) NSString * enName;    // enName
@property (nonatomic) NSString * sCardType; // sCardType
@property (nonatomic) NSString * cardDType;  // cardDType
@property (nonatomic) NSString * tribe;     // tribe
@property (nonatomic) NSString * package;   // package
@property (nonatomic) NSString * element;   // element
@property (nonatomic) NSInteger level;      // level
@property (nonatomic) NSString * infrequence;   // infrequence
@property (nonatomic) NSInteger atkValue;   // atkValue
@property (nonatomic) NSString * atk;       // atk
@property (nonatomic) NSInteger defValue;   // defValue
@property (nonatomic) NSString * def;       // def
@property (nonatomic) NSString * effect;    // effect
@property (nonatomic) NSString * ban;       // ban
@property (nonatomic) NSString * cheatcode; // cheatcode
@property (nonatomic) NSString * adjust;    // adjust
@property (nonatomic) NSString * cardCamp;  // cardCamp
@property (nonatomic) NSString * oldName;   // oldName
@property (nonatomic) NSString * shortName; // shortName
@property (nonatomic) NSInteger pendulumL;  // pendulumL
@property (nonatomic) NSInteger pendulumR;  // pendulumR

-(CardItem *) init;

@end
