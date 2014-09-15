#import "DatabaseUtils.h"

@implementation DatabaseUtils

static sqlite3 * _main_database;
static sqlite3 * _fav_database;

+ (BOOL) copyDatabaseFile {
    
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
        NSError * err;
        [fileMgr copyItemAtPath:oriMainDbPath toPath:mainDbPath error:&err];
        NSLog([err description]);
        
    }
    if (![fileMgr fileExistsAtPath:favDbPath]) {
        [fileMgr copyItemAtPath:oriFavDbPath toPath:favDbPath error:nil];
    }
    
    return [fileMgr fileExistsAtPath:mainDbPath] && [fileMgr fileExistsAtPath:favDbPath];
    
}

+ (sqlite3 *) _openDatabase: (NSString *) fileName {
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

+ (BOOL) openDatabase {
    _main_database = [self _openDatabase:@"yugioh.db"];
    _fav_database = [self _openDatabase:@"fav.db"];
    return (_main_database != nil) && (_fav_database != nil);
}

+ (void) closeDatabase {
    if (_main_database != nil) {
        sqlite3_close(_main_database);
    }
    if (_fav_database != nil) {
        sqlite3_close(_fav_database);
    }
}

+ (NSMutableArray *) buildDataArray: (sqlite3_stmt *) stmt {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        CardItem * item = [[CardItem alloc] init];
        item._id = sqlite3_column_int(stmt, 0);
        item.card_id = sqlite3_column_int(stmt, 1);
        item.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
        item.sCardType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
        [array addObject:item];
    }
    return array;
}

+ (NSMutableArray *) queryData:(NSString *)sql {
    sqlite3_stmt * stmt;
    NSMutableArray * array = nil;
    if (sqlite3_prepare_v2(_main_database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        array = [self buildDataArray:stmt];
        sqlite3_finalize(stmt);
    }
    return array;
}

+ (NSMutableArray *) queryFav:(NSString *)sql {
    return nil;
}

+ (CardItem *) queryOneCard:(NSInteger)cardId {
    sqlite3_stmt * stmt;
    CardItem * item = nil;
    NSString * sql = [NSString stringWithFormat:@"select * from YGODATA where _id=%ld", (long)cardId];
    
    if (sqlite3_prepare_v2(_main_database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            item = [[CardItem alloc] init];
            item._id = sqlite3_column_int(stmt, 0);
            item.card_id = sqlite3_column_int(stmt, 1);
            item.japName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 2)];
            item.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 3)];
            item.enName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 4)];
            item.sCardType = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 5)];
            item.cardDType = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 6)];
            item.tribe = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 7)];
            item.package = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 8)];
            item.element = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 9)];
            item.level = sqlite3_column_int(stmt, 10);
            item.infrequence = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 11)];
            item.atkValue = sqlite3_column_int(stmt, 12);
            item.atk = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 13)];
            item.defValue = sqlite3_column_int(stmt, 14);
            item.def = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 15)];
            item.effect = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 16)];
            item.ban = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 17)];
            item.cheatcode = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 18)];
            item.adjust = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 19)];
            item.cardCamp = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 20)];
            item.oldName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 21)];
            item.shortName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 22)];
            item.pendulumL = sqlite3_column_int(stmt, 23);
            item.pendulumR = sqlite3_column_int(stmt, 24);
            break;
        }
        sqlite3_finalize(stmt);
    }
    
    return item;
}


+ (NSMutableArray *) queryLast100 {
    NSString * sql = @"select _id, id, name, sCardType from YGODATA order by _id desc limit 0,100";
    return [self queryData:sql];
}

+ (NSMutableArray *) queryBanCards {
    NSString * sql = @"select _id, id, name, sCardType from YGODATA where ban='禁止卡' order by sCardType asc";
    return [self queryData:sql];
}

+ (NSMutableArray *) queryLimit1Cards {
    NSString * sql = @"select _id, id, name, sCardType from YGODATA where ban='限制卡' order by sCardType asc";
    return [self queryData:sql];
}

+ (NSMutableArray *) queryLimit2Cards {
    NSString * sql = @"select _id, id, name, sCardType from YGODATA where ban='准限制卡' order by sCardType asc";
    return [self queryData:sql];
}

+ (NSMutableArray *) queryCardsViaIds: (NSMutableArray *) cardIds {
    return nil;
}


+ (sqlite3 *) mainDatabase {
    return _main_database;
}

+ (sqlite3 *) favDatabase {
    return _fav_database;
}


@end

