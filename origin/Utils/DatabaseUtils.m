#import "DatabaseUtils.h"

@implementation DatabaseUtils

static sqlite3 * _main_database;
static sqlite3 * _fav_database;

#pragma mark - database

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
        [fileMgr copyItemAtPath:oriMainDbPath toPath:mainDbPath error:nil];
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


+ (sqlite3 *) mainDatabase {
    return _main_database;
}

+ (sqlite3 *) favDatabase {
    return _fav_database;
}

+ (int) getDatabaseVersion {
    NSString * sql = @"select ver from version";
    sqlite3_stmt * stmt;
    int ver = 0;
    if (sqlite3_prepare_v2(_main_database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            ver = sqlite3_column_int(stmt, 0);
            break;
        }
        sqlite3_finalize(stmt);
    }
    return ver;
}


#pragma mark - card data
+ (NSMutableArray *) buildDataArray: (sqlite3_stmt *) stmt {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        CardItem * item = [[CardItem alloc] init];
        item.card_id = sqlite3_column_int(stmt, 0);
        item.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
        item.sCardType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
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

+ (CardItem *) queryOneCard:(NSInteger)cardId {
    sqlite3_stmt * stmt;
    CardItem * item = nil;
    NSString * sql = [NSString stringWithFormat:@"select * from YGODATA where id=%ld", (long)cardId];
    
    if (sqlite3_prepare_v2(_main_database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            item = [[CardItem alloc] init];
            item.card_id = sqlite3_column_int(stmt, 0);
            item.japName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 1)];
            item.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 2)];
            item.enName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 3)];
            item.sCardType = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 4)];
            item.cardDType = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 5)];
            item.tribe = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 6)];
            item.package = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 7)];
            item.element = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 8)];
            item.level = sqlite3_column_int(stmt, 9);
            item.infrequence = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 10)];
            item.atkValue = sqlite3_column_int(stmt, 11);
            item.atk = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 12)];
            item.defValue = sqlite3_column_int(stmt, 13);
            item.def = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 14)];
            item.effect = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 15)];
            item.ban = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 16)];
            item.cheatcode = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 17)];
            item.adjust = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 18)];
            item.cardCamp = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 19)];
            item.oldName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 20)];
            item.shortName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 21)];
            item.pendulumL = sqlite3_column_int(stmt, 22);
            item.pendulumR = sqlite3_column_int(stmt, 23);
            break;
        }
        sqlite3_finalize(stmt);
    }
    
    return item;
}


+ (NSMutableArray *) queryLast100 {
    NSString * sql = @"select id, name, sCardType from YGODATA order by id desc limit 0,100";
    return [self queryData:sql];
}

+ (NSMutableArray *) queryBanCards {
    NSString * sql = @"select id, name, sCardType from YGODATA where ban='禁止卡' order by sCardType asc";
    return [self queryData:sql];
}

+ (NSMutableArray *) queryLimit1Cards {
    NSString * sql = @"select id, name, sCardType from YGODATA where ban='限制卡' order by sCardType asc";
    return [self queryData:sql];
}

+ (NSMutableArray *) queryLimit2Cards {
    NSString * sql = @"select id, name, sCardType from YGODATA where ban='准限制卡' order by sCardType asc";
    return [self queryData:sql];
}

+ (NSMutableArray *) queryCardsViaIds: (NSMutableArray *) cardIds {
    NSString * con = @"";
    for (NSInteger i=0; i<cardIds.count; i++) {
        con = [con stringByAppendingFormat:@"%d,",[(NSNumber *)cardIds[i] intValue]];
    }
    if (![con isEqualToString:@""]) {
        con = [con substringToIndex:con.length-1];
    }
    NSMutableArray * arr = nil;
    if (![con isEqualToString:@""]) {
        NSString * sql = [NSString stringWithFormat:@"select id, name, sCardType from YGODATA where id in (%@)", con];
        arr = [self queryData:sql];
    }
    if (arr == nil) {
        arr = [[NSMutableArray alloc] init];
    }
    return arr;
}

+ (int) queryLastCardId {
    int cardId = 0;
    NSString * sql = @"select id from YGODATA order by id desc limit 0,1";
    sqlite3_stmt * stmt;
    if (sqlite3_prepare_v2(_main_database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            cardId = sqlite3_column_int(stmt, 0);
            break;
        }
        sqlite3_finalize(stmt);
    }
    return cardId;
}

#pragma mark - fav data

+ (void) favAdd: (NSInteger) cardId {
    NSString * sql = [NSString stringWithFormat:@"insert into fav (cardId) values (%ld)", (long) cardId];
    sqlite3_exec(_fav_database, [sql UTF8String], nil, nil, nil);
}

+ (void) favRemove: (NSInteger) cardId {
    NSString * sql = [NSString stringWithFormat:@"delete from fav where cardId=%ld", (long) cardId];
    sqlite3_exec(_fav_database, [sql UTF8String], nil, nil, nil);
}

+ (BOOL) favExists: (NSInteger) cardId {
    BOOL ret = NO;
    NSString * sql = [NSString stringWithFormat:@"select cardId from fav where cardId=%ld", (long)cardId];
    sqlite3_stmt * stmt;
    if (sqlite3_prepare_v2(_fav_database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            ret = YES;
            break;
        }
        sqlite3_finalize(stmt);
    }
    return ret;
}

+ (NSMutableArray *) favQuery {
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    NSString * sql = @"select * from fav";
    sqlite3_stmt * stmt;
    if (sqlite3_prepare_v2(_fav_database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            [arr addObject:[NSNumber numberWithInt:sqlite3_column_int(stmt, 0)]];
        }
        sqlite3_finalize(stmt);
    }
    return arr;
}


@end

