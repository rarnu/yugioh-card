#import "PackItem.h"

#pragma mark - package cards
@implementation PackageCards

-(PackageCards *) init {
    self = [super init];
    if (self) {
        self.cards = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

#pragma mark - package detail

@implementation PackageDetail

-(PackageDetail *) initWithId:(NSString *)packid packName:(NSString *)packName {
    self = [super init];
    if (self) {
        self.packId = packid;
        self.packName = packName;
    }
    return self;
}

@end

#pragma mark - package item

@implementation PackItem

-(PackItem *) init {
    self = [super init];
    if (self) {
        self.packages = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addPackage:(PackageDetail *)item {
    [self.packages addObject:item];
}

@end
