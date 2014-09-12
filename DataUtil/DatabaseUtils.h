#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "CardItem.h"

@interface DatabaseUtils : NSObject

+ (void) copyDatabaseFile;
+ (void) openDatabase;
+ (void) closeDatabase;
+ (NSMutableArray *) queryData:(NSString *)sql;
+ (NSMutableArray *) queryFav: (NSString *)sql;
+ (CardItem *) queryOneCard: (NSInteger) cardId;

+ (NSMutableArray *) queryLast100;
+ (NSMutableArray *) queryBanCards;
+ (NSMutableArray *) queryLimit1Cards;
+ (NSMutableArray *) queryLimit2Cards;
+ (NSMutableArray *) queryCardsViaIds: (NSMutableArray *) cardIds;

// get database instance
+ (sqlite3 *) mainDatabase;
+ (sqlite3 *) favDatabase;

@end
