#import "DatabaseUtils.h"

@implementation DatabaseUtils

+ (void) copyDatabaseFile {
    
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    NSBundle * bundle = [NSBundle mainBundle];
    NSString * oriMainDbPath = [bundle pathForResource:@"yugioh" ofType:@"db"];
    NSString * oriFavDbPath = [bundle pathForResource:@"fav" ofType:@"db"];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * document = [paths objectAtIndex:0];
    NSString * mainDbPath = [document stringByAppendingPathComponent:@"yugioh.db"];
    NSString * favDbPath = [document stringByAppendingPathComponent:@"fav.db"];
    [[NSFileManager defaultManager] createDirectoryAtPath:document withIntermediateDirectories:YES attributes:nil error:nil];
    if (![fileMgr fileExistsAtPath:mainDbPath]) {
        [fileMgr copyItemAtPath:oriMainDbPath toPath:mainDbPath error:nil];
    }
    if (![fileMgr fileExistsAtPath:favDbPath]) {
        [fileMgr copyItemAtPath:oriFavDbPath toPath:favDbPath error:nil];
    }
    
}

+ (sqlite3 *) openDatabase:(NSString *)fileName {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * document = [paths objectAtIndex:0];
    NSString * dbFilePath = [document stringByAppendingPathComponent:fileName];
    
    sqlite3 * database;
    if (sqlite3_open([dbFilePath UTF8String], &database) == SQLITE_OK) {
        return database;
    } else {
        sqlite3_close(database);
        return nil;
    }
}

+ (void) closeDatabase:(sqlite3 *)database {
    sqlite3_close(database);
}

+ (sqlite3_stmt *) queryData:(sqlite3 *)database sql:(NSString *)sql {
    sqlite3_stmt * stmt;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        return stmt;
    } else {
        sqlite3_finalize(stmt);
        return nil;
    }
}

+ (void) queryEnd:(sqlite3_stmt *)stmt {
    sqlite3_finalize(stmt);
}

@end

