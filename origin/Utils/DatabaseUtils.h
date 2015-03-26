#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "CardItem.h"

@interface DatabaseUtils : NSObject

// database
+ (BOOL) copyDatabaseFile;
+ (BOOL) openDatabase;
+ (void) closeDatabase;
+ (sqlite3 *) mainDatabase;
+ (sqlite3 *) favDatabase;
+ (int) getDatabaseVersion;

// card data
+ (NSMutableArray *) queryData:(NSString *)sql;
+ (CardItem *) queryOneCard: (NSInteger) cardId;
+ (NSMutableArray *) queryLast100;
+ (NSMutableArray *) queryBanCards;
+ (NSMutableArray *) queryLimit1Cards;
+ (NSMutableArray *) queryLimit2Cards;
+ (NSMutableArray *) queryCardsViaIds: (NSMutableArray *) cardIds;
+ (int) queryLastCardId;
+ (int) queryCardCount;

// fav data
+ (void) favAdd: (NSInteger) cardId;
+ (void) favRemove: (NSInteger) cardId;
+ (BOOL) favExists: (NSInteger) cardId;
+ (NSMutableArray *) favQuery;

@end
