import UIKit

var _main_database: OpaquePointer? = nil
var _fav_database: OpaquePointer? = nil

class DatabaseUtils: NSObject {
   
    class func copyDatabaseFile() -> Bool {
        let fileMgr = FileManager.default
        let bundle = Bundle.main
        let oriMainDbPath = bundle.path(forResource: "yugioh", ofType: "db")
        let oriFavDbPath = bundle.path(forResource: "fav", ofType: "db")
        let document = FileUtils.getDocumentPath()
        let mainDbPath = "\(document)/yugioh.db"
        let favDbPath = "\(document)/fav.db"
        do {
            try fileMgr.createDirectory(atPath: document, withIntermediateDirectories: true, attributes: nil)
        } catch _ {
        }
        if (!fileMgr.fileExists(atPath: mainDbPath)) {
            do {
                try fileMgr.copyItem(atPath: oriMainDbPath!, toPath: mainDbPath)
            } catch _ {
            }
        }
        if (!fileMgr.fileExists(atPath: favDbPath)) {
            do {
                try fileMgr.copyItem(atPath: oriFavDbPath!, toPath: favDbPath)
            } catch _ {
            }
        }
        return fileMgr.fileExists(atPath: mainDbPath) && fileMgr.fileExists(atPath: favDbPath)
    
    }
    
    class func updateDatabase() {
        let currVer = getDatabaseVersion();
        let innerVer = getDatabaseVersionFromAssets();
        if (innerVer > currVer) {
            closeDatabase()
            let document = FileUtils.getDocumentPath()
            let mainDbPath: String = "\(document)/yugioh.db"
            do {
                try FileManager.default.removeItem(atPath: mainDbPath)
            } catch _ {
            }
            var updated = copyDatabaseFile()
            if (updated) {
                updated = openDatabase()
                NSLog("updated database: \(updated)")
            }
        }
    }
    
    class func _openDatabase(fileName: String) -> OpaquePointer? {
        let document = FileUtils.getDocumentPath()
        let dbFilePath = "\(document)/\(fileName)" as NSString
        var database: OpaquePointer? = nil
        if (sqlite3_open(dbFilePath.cString(using: String.Encoding.utf8.rawValue), &database) == SQLITE_OK) {
            return database
        } else {
            sqlite3_close(database)
            return nil
        }
    }
    
    class func openDatabase() -> Bool {
        _main_database = self._openDatabase(fileName: "yugioh.db")
        _fav_database = self._openDatabase(fileName: "fav.db")
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
    
    
    class func mainDatabase() -> OpaquePointer? {
        return _main_database
    }
    
    class func favDatabase() -> OpaquePointer? {
        return _fav_database
    }
    
    class func getDatabaseVersion() -> Int {
        let sql = "select ver from version" as NSString
        var stmt: OpaquePointer? = nil
        var ver: Int = 0

        if (sqlite3_prepare_v2(_main_database, sql.utf8String, -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                ver = Int(sqlite3_column_int(stmt, 0))
                break
            }
            sqlite3_finalize(stmt)
        }
        return ver
    }
    
    class func getDatabaseVersionFromAssets() -> Int {
        let assetsDbPath: NSString? = Bundle.main.path(forResource: "yugioh", ofType: "db") as NSString?
        var db: OpaquePointer? = nil
        var ret: Int = 0
        if (sqlite3_open(assetsDbPath!.cString(using: String.Encoding.utf8.rawValue), &db) == SQLITE_OK) {
            let sql = "select ver from version" as NSString
            var stmt: OpaquePointer? = nil
            
            if (sqlite3_prepare_v2(db, sql.utf8String, -1, &stmt, nil) == SQLITE_OK) {
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
    
    class func buildDataArray(stmt: OpaquePointer) -> NSMutableArray? {
        let array = NSMutableArray()

        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let item = CardItem()
            item._id = Int(sqlite3_column_int(stmt, 0))
            item.name = String(cString: UnsafePointer(sqlite3_column_text(stmt, 1)))
            item.sCardType = String(cString: UnsafePointer(sqlite3_column_text(stmt, 2)))
            array.add(item)
        }
        return array
    }
    
    class func queryData(sql: String) -> NSMutableArray? {
        var stmt: OpaquePointer? = nil
        var array: NSMutableArray? = nil
        if (sqlite3_prepare_v2(_main_database, (sql as NSString).utf8String, -1, &stmt, nil) == SQLITE_OK) {
            array = self.buildDataArray(stmt: stmt!)
            sqlite3_finalize(stmt)
        }
        return array
    }
    
    class func queryOneCard(cardId: Int) -> CardItem? {
        var stmt: OpaquePointer? = nil
        var item: CardItem? = nil
        let sql = "select * from YGODATA where _id=\(cardId)" as NSString
    
        if (sqlite3_prepare_v2(_main_database, sql.utf8String, -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                item = CardItem()
                item!._id = Int(sqlite3_column_int(stmt, 0))
                item!.japName = String(cString: UnsafePointer(sqlite3_column_text(stmt, 1)))
                item!.name = String(cString: UnsafePointer(sqlite3_column_text(stmt, 2)))
                item!.enName = String(cString: UnsafePointer(sqlite3_column_text(stmt, 3)))
                item!.sCardType = String(cString: UnsafePointer(sqlite3_column_text(stmt, 4)))
                item!.cardDType = String(cString: UnsafePointer(sqlite3_column_text(stmt, 5)))
                item!.tribe = String(cString: UnsafePointer(sqlite3_column_text(stmt, 6)))
                item!.package = String(cString: UnsafePointer(sqlite3_column_text(stmt, 7)))
                item!.element = String(cString: UnsafePointer(sqlite3_column_text(stmt, 8)))
                item!.level = Int(sqlite3_column_int(stmt, 9))
                item!.infrequence = String(cString: UnsafePointer(sqlite3_column_text(stmt, 10)))
                item!.atkValue = Int(sqlite3_column_int(stmt, 11))
                item!.atk = String(cString: UnsafePointer(sqlite3_column_text(stmt, 12)))
                item!.defValue = Int(sqlite3_column_int(stmt, 13))
                item!.def = String(cString: UnsafePointer(sqlite3_column_text(stmt, 14)))
                item!.effect = String(cString: UnsafePointer(sqlite3_column_text(stmt, 15)))
                item!.ban = String(cString: UnsafePointer(sqlite3_column_text(stmt, 16)))
                item!.cheatcode = String(cString: UnsafePointer(sqlite3_column_text(stmt, 17)))
                item!.adjust = String(cString: UnsafePointer(sqlite3_column_text(stmt, 18)))
                item!.cardCamp = String(cString: UnsafePointer(sqlite3_column_text(stmt, 19)))
                item!.oldName = String(cString: UnsafePointer(sqlite3_column_text(stmt, 20)))
                item!.shortName = String(cString: UnsafePointer(sqlite3_column_text(stmt, 21)))
                item!.pendulumL = Int(sqlite3_column_int(stmt, 22))
                item!.pendulumR = Int(sqlite3_column_int(stmt, 23))
                item!.link = Int(sqlite3_column_int(stmt, 24))
                item!.linkArrow = String(cString: UnsafePointer(sqlite3_column_text(stmt, 25)))
                break
            }
            sqlite3_finalize(stmt)
        }
    
        return item
    }

    class func queryLast100() -> NSMutableArray? {
        let sql = "select _id, name, sCardType from YGODATA order by _id desc limit 0,100"
        return self.queryData(sql: sql)
    }
    
    class func queryBanCards() -> NSMutableArray? {
        let sql = "select _id, name, sCardType from YGODATA where ban='禁止卡' order by sCardType asc"
        return self.queryData(sql: sql)
    }
    
    class func queryLimit1Cards() -> NSMutableArray? {
        let sql = "select _id, name, sCardType from YGODATA where ban='限制卡' order by sCardType asc"
        return self.queryData(sql: sql)
    }
    
    class func queryLimit2Cards() -> NSMutableArray? {
        let sql = "select _id, name, sCardType from YGODATA where ban='准限制卡' order by sCardType asc"
        return self.queryData(sql: sql)
    }
    
    class func queryCardsViaIds(cardIds:NSMutableArray) -> NSMutableArray? {
        var con = ""
        for i in 0 ..< cardIds.count {
            con += "\((cardIds[i] as! NSNumber).intValue),"
        }
        if (con != "") {
            var con_t = con as NSString
            con_t = con_t.substring(to: con_t.length - 1) as NSString
            con = con_t as String
        }
        var arr: NSMutableArray? = nil
        if (con != "") {
            let sql = "select _id, name, sCardType from YGODATA where _id in (\(con))"
            arr = self.queryData(sql: sql)
        }
        if (arr == nil) {
            arr = NSMutableArray()
        }
        return arr
    }
    
    class func queryCardCount() -> Int {
        var cardCount: Int = 0
        let sql = "select count(*) from YGODATA" as NSString
        var stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(_main_database, sql.utf8String, -1, &stmt, nil) == SQLITE_OK) {
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
        var stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(_main_database, sql.utf8String, -1, &stmt, nil) == SQLITE_OK) {
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
        sqlite3_exec(_fav_database, sql.utf8String, nil, nil, nil)
    }
    
    class func favRemove(cardId: Int) {
        let sql = "delete from fav where cardId=\(cardId)" as NSString
        sqlite3_exec(_fav_database, sql.utf8String, nil, nil, nil)
    }
    
    class func favExists(cardId: Int) -> Bool {
        var ret = false
        let sql = "select cardId from fav where cardId=\(cardId)" as NSString
        var stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(_fav_database, sql.utf8String, -1, &stmt, nil) == SQLITE_OK) {
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
        var stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(_fav_database, sql.utf8String, -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                arr.add(NSNumber(value: Int32(sqlite3_column_int(stmt, 0))))
            }
            sqlite3_finalize(stmt)
        }
        return arr
    }
    
}
