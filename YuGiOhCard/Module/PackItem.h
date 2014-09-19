#import <Foundation/Foundation.h>

@interface PackageCards : NSObject

@property NSString * name;
@property NSMutableArray * cards;

-(PackageCards *) init;

@end

@interface PackageDetail : NSObject

@property NSString * packId;
@property NSString * packName;

-(PackageDetail *) initWithId: (NSString *) packid packName: (NSString *) packName;

@end


@interface PackItem : NSObject

@property (strong, nonatomic) NSString * serial;
@property (strong, nonatomic) NSMutableArray * packages;

-(PackItem *) init;
-(void) addPackage: (PackageDetail *) item;

@end

