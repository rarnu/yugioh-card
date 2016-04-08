import UIKit

var _main_database: COpaquePointer = nil
var _fav_database: COpaquePointer = nil

class DatabaseUtils: NSObject {
   
    class func copyDatabaseFile() -> Bool {
        let fileMgr = NSFileManager.defaultManager()
        let bundle = NSBundle.mainBundle()
        let oriMainDbPath: String? = bundle.pathForResource("yugioh", ofType: "db")
        let oriFavDbPath: String? = bundle.pathForResource("fav", ofType: "db")
        let document = FileUtils.getDocumentPath()
        let mainDbPath: String = "\(document)/yugioh.db"
        let favDbPath: String = "\(document)/fav.db"
        do {
            try fileMgr.createDirectoryAtPath(document, withIntermediateDirectories: true, attributes: nil)
        } catch _ {
        }
        if (!fileMgr.fileExistsAtPath(mainDbPath)) {
            do {
                try fileMgr.copyItemAtPath(oriMainDbPath!, toPath: mainDbPath)
            } catch _ {
            }
        }
        if (!fileMgr.fileExistsAtPath(favDbPath)) {
            do {
                try fileMgr.copyItemAtPath(oriFavDbPath!, toPath: favDbPath)
            } catch _ {
            }
        }
        return fileMgr.fileExistsAtPath(mainDbPath) && fileMgr.fileExistsAtPath(favDbPath)
    
    }
    
    class func updateDatabase() {
        let currVer = getDatabaseVersion();
        let innerVer = getDatabaseVersionFromAssets();
        if (innerVer > currVer) {
            closeDatabase()
            let document = FileUtils.getDocumentPath()
            let mainDbPath: String = "\(document)/yugioh.db"
            do {
                try NSFileManager.defaultManager().removeItemAtPath(mainDbPath)
            } catch _ {
            }
            var updated = copyDatabaseFile()
            if (updated) {
                updated = openDatabase()
                NSLog("updated database: \(updated)")
            }
        }
    }
    
    class func _openDatabase(fileName: String) -> COpaquePointer {
        let document = FileUtils.getDocumentPath()
        let dbFilePath = "\(document)/\(fileName)" as NSString
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
        let sql = "select ver from version" as NSString
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
    
    class func getDatabaseVersionFromAssets() -> Int {
        let assetsDbPath: NSString? = NSBundle.mainBundle().pathForResource("yugioh", ofType: "db")
        var db: COpaquePointer = nil
        var ret: Int = 0
        if (sqlite3_open(assetsDbPath!.cStringUsingEncoding(NSUTF8StringEncoding), &db) == SQLITE_OK) {
            let sql = "select ver from version" as NSString
            var stmt: COpaquePointer = nil
            
            if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil) == SQLITE_OK) {
                while (sqlite3_step(stmt) == SQLITE_ROW) {
                    ret = Int(sqlite3_column_int(stmt, 0))
                    break
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(db)
        }
        return ret
    }
    
    class func buildDataArray(stmt: COpaquePointer) -> NSMutableArray? {
        let array = NSMutableArray()

        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let item = CardItem()
            item._id = Int(sqlite3_column_int(stmt, 0))
            item.name = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 1)))!
            item.sCardType = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 2)))!
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
        let sql = "select * from YGODATA where _id=\(cardId)" as NSString
    
        if (sqlite3_prepare_v2(_main_database, sql.UTF8String, -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                item = CardItem()
                item!._id = Int(sqlite3_column_int(stmt, 0))
                item!.japName = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 1)))!
                item!.name = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 2)))!
                item!.enName = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 3)))!
                item!.sCardType = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 4)))!
                item!.cardDType = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 5)))!
                item!.tribe = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 6)))!
                item!.package = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 7)))!
                item!.element = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 8)))!
                item!.level = Int(sqlite3_column_int(stmt, 9))
                item!.infrequence = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 10)))!
                item!.atkValue = Int(sqlite3_column_int(stmt, 11))
                item!.atk = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 12)))!
                item!.defValue = Int(sqlite3_column_int(stmt, 13))
                item!.def = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 14)))!
                item!.effect = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 15)))!
                item!.ban = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 16)))!
                item!.cheatcode = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 17)))!
                item!.adjust = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 18)))!
                item!.cardCamp = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 19)))!
                item!.oldName = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 20)))!
                item!.shortName = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(stmt, 21)))!
                item!.pendulumL = Int(sqlite3_column_int(stmt, 22))
                item!.pendulumR = Int(sqlite3_column_int(stmt, 23))
                break
            }
            sqlite3_finalize(stmt)
        }
    
        return item
    }

    class func queryLast100() -> NSMutableArray? {
        let sql = "select _id, name, sCardType from YGODATA order by _id desc limit 0,100"
        return self.queryData(sql)
    }
    
    class func queryBanCards() -> NSMutableArray? {
        let sql = "select _id, name, sCardType from YGODATA where ban='禁止卡' order by sCardType asc"
        return self.queryData(sql)
    }
    
    class func queryLimit1Cards() -> NSMutableArray? {
        let sql = "select _id, name, sCardType from YGODATA where ban='限制卡' order by sCardType asc"
        return self.queryData(sql)
    }
    
    class func queryLimit2Cards() -> NSMutableArray? {
        let sql = "select _id, name, sCardType from YGODATA where ban='准限制卡' order by sCardType asc"
        return self.queryData(sql)
    }
    
    class func queryCardsViaIds(cardIds:NSMutableArray) -> NSMutableArray? {
        var con = ""
        for i in 0 ..< cardIds.count {
            con += "\((cardIds[i] as! NSNumber).integerValue),"
        }
        if (con != "") {
            var con_t = con as NSString
            con_t = con_t.substringToIndex(con_t.length - 1)
            con = con_t as String
        }
        var arr: NSMutableArray? = nil
        if (con != "") {
            let sql = "select _id, name, sCardType from YGODATA where _id in (\(con))"
            arr = self.queryData(sql)
        }
        if (arr == nil) {
            arr = NSMutableArray()
        }
        return arr
    }
    
    class func queryCardCount() -> Int {
        var cardCount: Int = 0
        let sql = "select count(*) from YGODATA" as NSString
        var stmt: COpaquePointer = nil
        if (sqlite3_prepare_v2(_main_database, sql.UTF8String, -1, &stmt, nil) == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                cardCount = Int(sqlite3_column_int(stmt, 0))
            }
            sqlite3_finalize(stmt)
        }
        return cardCount
    }
    
    class func queryLastCardId() -> Int {
        var cardId: Int = 0
        let sql = "select _id from YGODATA order by _id desc limit 0,1" as NSString
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
        let sql = "insert into fav (cardId) values (\(cardId))" as NSString
        sqlite3_exec(_fav_database, sql.UTF8String, nil, nil, nil)
    }
    
    class func favRemove(cardId: Int) {
        let sql = "delete from fav where cardId=\(cardId)" as NSString
        sqlite3_exec(_fav_database, sql.UTF8String, nil, nil, nil)
    }
    
    class func favExists(cardId: Int) -> Bool {
        var ret = false
        let sql = "select cardId from fav where cardId=\(cardId)" as NSString
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
        let arr = NSMutableArray()
        let sql = "select * from fav" as NSString
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
