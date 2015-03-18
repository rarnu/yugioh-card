#import "CardItem.h"

@implementation CardItem

-(CardItem *) init {
    self = [super init];
    if (self) {
        self._id = 0;
        self.japName = @"";
        self.name = @"";
        self.enName = @"";
        self.sCardType = @"";
        self.cardDType = @"";
        self.tribe = @"";
        self.package = @"";
        self.element = @"";
        self.level = 0;
        self.infrequence = @"";
        self.atkValue = 0;
        self.atk = @"";
        self.defValue = 0;
        self.def = @"";
        self.effect = @"";
        self.ban = @"";
        self.cheatcode = @"";
        self.adjust = @"";
        self.cardCamp = @"";
        self.oldName = @"";
        self.shortName = @"";
        self.pendulumL = 0;
        self.pendulumR = 0;
        
    }
    return self;
}

@end
