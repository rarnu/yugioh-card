#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseUtils : NSObject

+ (void) copyDatabaseFile;
+ (sqlite3 *) openDatabase:(NSString *)fileName;
+ (void) closeDatabase:(sqlite3 *)database;
+ (sqlite3_stmt *) queryData:(sqlite3 *)database sql:(NSString *)sql;
+ (void) queryEnd:(sqlite3_stmt *)stmt;

@end
