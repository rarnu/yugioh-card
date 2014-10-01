import UIKit

var _main_database: COpaquePointer = nil
var _fav_database: COpaquePointer = nil

class DatabaseUtils: NSObject {
   
    class func copyDatabaseFile() -> Bool {
        var fileMgr = NSFileManager.defaultManager()
        var bundle = NSBundle.mainBundle()
        var oriMainDbPath: String? = bundle.pathForResource("yugioh", ofType: "db")
        var oriFavDbPath: String? = bundle.pathForResource("fav", ofType: "db")
        
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
        var document = paths[0] as String
        var mainDbPath: String = "\(document)/yugioh.db"
        var favDbPath: String = "\(document)/fav.db"
        fileMgr.createDirectoryAtPath(document, withIntermediateDirectories: true, attributes: nil, error: nil)
        if (!fileMgr.fileExistsAtPath(mainDbPath)) {
            fileMgr.copyItemAtPath(oriMainDbPath!, toPath: mainDbPath, error: nil)
        }
        if (!fileMgr.fileExistsAtPath(favDbPath)) {
            fileMgr.copyItemAtPath(oriFavDbPath!, toPath: favDbPath, error: nil)
        }
        return fileMgr.fileExistsAtPath(mainDbPath) && fileMgr.fileExistsAtPath(favDbPath)
    
    }
    
    class func _openDatabase(fileName: String) -> COpaquePointer {
        
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
        var document = paths[0] as String
        var dbFilePath = "\(document)/\(fileName)" as NSString
        var database: COpaquePointer = nil
        if (sqlite3_open(dbFilePath.cStringUsingEncoding(NSUTF8StringEncoding), &database) == SQLITE_OK) {
            return database
        } else {
            sqlite3_close(database)
            return nil
        }
    }
    
    class func openDatabase() -> Bool {
        _main_database = self._openDatabase("yugioh.db")
        _fav_database = self._openDatabase("fav.db")
        return (_main_database != nil) && (_fav_database != nil);
    }
    
    class func closeDatabase() {
        if (_main_database != nil) {
            sqlite3_close(_main_database);
        }
        if (_fav_database != nil) {
            sqlite3_close(_fav_database);
        }
    }
    
    
    class func mainDatabase() -> COpaquePointer {
        return _main_database
    }
    
    class func favDatabase() -> COpaquePointer {
        return _fav_database
    }
    
    class func getDatabaseVersion() -> Int {
        var sql = "select ver from version" as NSString
        var stmt: COpaquePointer = nil
        var ver: Int = 0

        if (sqlite3_prepare_v2(_main_database, sql.UTF8String, -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                ver = Int(sqlite3_column_int(stmt, 0))
                break
            }
            sqlite3_finalize(stmt)
        }
        return ver
    }
    
    class func buildDataArray(stmt: COpaquePointer) -> NSMutableArray? {
        var array = NSMutableArray()

        while (sqlite3_step(stmt) == SQLITE_ROW) {
            var item = CardItem()
            item._id = Int(sqlite3_column_int(stmt, 0))
            item.card_id = Int(sqlite3_column_int(stmt, 1))
            item.name = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 2)))!
            item.sCardType = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 3)))!
            array.addObject(item)
        }
        return array
    }
    
    class func queryData(sql: String) -> NSMutableArray? {
        var stmt: COpaquePointer = nil
        var array: NSMutableArray? = nil
        if (sqlite3_prepare_v2(_main_database, (sql as NSString).UTF8String, -1, &stmt, nil) == SQLITE_OK) {
            array = self.buildDataArray(stmt)
            sqlite3_finalize(stmt)
        }
        return array
    }
    
    class func queryOneCard(cardId: Int) -> CardItem? {
        var stmt: COpaquePointer = nil
        var item: CardItem? = nil
        var sql = "select * from YGODATA where _id=\(cardId)" as NSString
    
        if (sqlite3_prepare_v2(_main_database, sql.UTF8String, -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                item = CardItem()
                item!._id = Int(sqlite3_column_int(stmt, 0))
                item!.card_id = Int(sqlite3_column_int(stmt, 1))
                item!.japName = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 2)))!
                item!.name = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 3)))!
                item!.enName = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 4)))!
                item!.sCardType = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 5)))!
                item!.cardDType = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 6)))!
                item!.tribe = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 7)))!
                item!.package = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 8)))!
                item!.element = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 9)))!
                item!.level = Int(sqlite3_column_int(stmt, 10))
                item!.infrequence = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 11)))!
                item!.atkValue = Int(sqlite3_column_int(stmt, 12))
                item!.atk = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 13)))!
                item!.defValue = Int(sqlite3_column_int(stmt, 14))
                item!.def = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 15)))!
                item!.effect = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 16)))!
                item!.ban = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 17)))!
                item!.cheatcode = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 18)))!
                item!.adjust = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 19)))!
                item!.cardCamp = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 20)))!
                item!.oldName = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 21)))!
                item!.shortName = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 22)))!
                item!.pendulumL = Int(sqlite3_column_int(stmt, 23))
                item!.pendulumR = Int(sqlite3_column_int(stmt, 24))
                break
            }
            sqlite3_finalize(stmt)
        }
    
        return item
    }

    class func queryLast100() -> NSMutableArray? {
        var sql = "select _id, id, name, sCardType from YGODATA order by _id desc limit 0,100"
        return self.queryData(sql)
    }
    
    class func queryBanCards() -> NSMutableArray? {
        var sql = "select _id, id, name, sCardType from YGODATA where ban='禁止卡' order by sCardType asc"
        return self.queryData(sql)
    }
    
    class func queryLimit1Cards() -> NSMutableArray? {
        var sql = "select _id, id, name, sCardType from YGODATA where ban='限制卡' order by sCardType asc"
        return self.queryData(sql)
    }
    
    class func queryLimit2Cards() -> NSMutableArray? {
        var sql = "select _id, id, name, sCardType from YGODATA where ban='准限制卡' order by sCardType asc"
        return self.queryData(sql)
    }
    
    class func queryCardsViaIds(cardIds:NSMutableArray) -> NSMutableArray? {
        var con = ""
        
        for (var i=0; i < cardIds.count; i++) {
            con += "\((cardIds[i] as NSNumber).integerValue),"
        }
        if (con != "") {
            var con_t = con as NSString
            con_t = con_t.substringToIndex(con_t.length - 1)
            con = con_t as String
        }
        var arr: NSMutableArray? = nil
        if (con != "") {
            var sql = "select _id, id, name, sCardType from YGODATA where id in (\(con))"
            arr = self.queryData(sql)
        }
        if (arr == nil) {
            arr = NSMutableArray()
        }
        return arr
    }
    
    class func queryLastCardId() -> Int {
        var cardId: Int = 0
        var sql = "select id from YGODATA order by id desc limit 0,1" as NSString
        var stmt: COpaquePointer = nil
        if (sqlite3_prepare_v2(_main_database, sql.UTF8String, -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                cardId = Int(sqlite3_column_int(stmt, 0))
                break
            }
            sqlite3_finalize(stmt)
        }
        return cardId
    }

    
    class func favAdd(cardId: Int) {
        var sql = "insert into fav (cardId) values (\(cardId))" as NSString
        sqlite3_exec(_fav_database, sql.UTF8String, nil, nil, nil)
    }
    
    class func favRemove(cardId: Int) {
        var sql = "delete from fav where cardId=\(cardId)" as NSString
        sqlite3_exec(_fav_database, sql.UTF8String, nil, nil, nil)
    }
    
    class func favExists(cardId: Int) -> Bool {
        var ret = false
        var sql = "select cardId from fav where cardId=\(cardId)" as NSString
        var stmt: COpaquePointer = nil
        if (sqlite3_prepare_v2(_fav_database, sql.UTF8String, -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                ret = true
                break
            }
            sqlite3_finalize(stmt)
        }
        return ret
    }
    
    class func favQuery() -> NSMutableArray? {
        var arr = NSMutableArray()
        var sql = "select * from fav" as NSString
        var stmt: COpaquePointer = nil
        if (sqlite3_prepare_v2(_fav_database, sql.UTF8String, -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                arr.addObject(NSNumber(int: Int32(sqlite3_column_int(stmt, 0))))
            }
            sqlite3_finalize(stmt)
        }
        return arr
    }
    
}
