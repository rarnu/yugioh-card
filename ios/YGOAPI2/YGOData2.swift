//
//  YGOData2.swift
//  YGOAPI2
//
//  Created by rarnu on 2019/2/8.
//  Copyright © 2019 rarnu. All rights reserved.
//

import UIKit

public class PackageInfo2: NSObject {
    public var season = ""
    public var url = ""
    public var name = ""
    public var abbr = ""
}

public class LimitInfo2: NSObject {
    public var limit = 0
    public var color = ""
    public var hashid = ""
    public var name = ""
}

public class CardPackInfo2: NSObject {
    public var url = ""
    public var name = ""
    public var date = ""
    public var abbr = ""
    public var rare = ""
}

public class CardDetail2: NSObject {
    public var name = ""
    public var japname = ""
    public var enname = ""
    public var cardtype = ""
    public var password = ""
    public var limit = ""
    public var belongs = ""
    public var rare = ""
    public var pack = ""
    public var effect = ""
    public var race = ""
    public var element = ""
    public var level = ""
    public var atk = ""
    public var def = ""
    public var link = ""
    public var linkarrow = ""
    public var packs = Array<CardPackInfo2>()
    public var adjust = ""
    public var wiki = ""
    public var imageId = -1;
}

public class CardInfo2: NSObject {
    public var cardid = 0
    public var hashid = ""
    public var name = ""
    public var japname = ""
    public var enname = ""
    public var cardtype = ""
}

public class SearchResult2: NSObject {
    public var data = Array<CardInfo2>()
    public var page = 0
    public var pageCount = 0
}

public class HotCard2: NSObject {
    public var hashid = ""
    public var name = ""
}

public class HotPack2: NSObject {
    public var packid = ""
    public var name = ""
}

public class Hotest2: NSObject {
    public var search = Array<String>()
    public var card = Array<HotCard2>()
    public var pack = Array<HotPack2>()
}

public class DeckTheme: Comparable {
    public static func < (lhs: DeckTheme, rhs: DeckTheme) -> Bool {
        return false
    }
    
    public static func == (lhs: DeckTheme, rhs: DeckTheme) -> Bool {
        return lhs.code == rhs.code && lhs.name == rhs.name
    }
    
    public var code = ""
    public var name = ""
}

public class DeckCategory: Comparable {
    public static func < (lhs: DeckCategory, rhs: DeckCategory) -> Bool {
        return false
    }
    
    public static func == (lhs: DeckCategory, rhs: DeckCategory) -> Bool {
        return lhs.guid == rhs.guid && lhs.name == rhs.name
    }
    
    public var guid = ""
    public var name = ""
}

public class DeckCard: NSObject {
    public var count = 0
    public var name = ""
    public init(_ c: Int, _ n: String) {
        self.count = c
        self.name = n
    }
}

public class DeckDetail: NSObject {
    public var name = ""
    public var monster = [DeckCard]()
    public var magictrap = [DeckCard]()
    public var extra = [DeckCard]()
    public var image = ""
}

public class YGOData2: NSObject {

    public class func searchCommon(_ key: String, _ page: Int, _ callback:@escaping (SearchResult2) -> Void) {
        YGORequest2.search(key, page) { data in
            callback(parseSearchResult(data))
        }
    }
    
    public class func searchComplex(name: String, japname: String, enname: String, race: String, element: String, atk: String, def: String, level: String, pendulum: String, link: String, linkArrow: String, cardType: String, cardType2: String, effect: String, page: Int, _ callback:@escaping (SearchResult2) -> Void) {
        var key = ""
        if (name != "") {
            key += " +(name:\(name))"
        }
        if (japname != "") {
            key += " +(japName:\(japname)"
        }
        if (enname != "") {
            key += " +(enName:\(enname)"
        }
        if (race != "") {
            key += " +(race:\(race)"
        }
        if (element != "") {
            key += " +(element:\(element)"
        }
        if (atk != "") {
            key += " +(atk:\(atk)"
        }
        if (def != "") {
            key += " +(def:\(def)"
        }
        if (level != "") {
            key += " +(level:\(level)"
        }
        if (pendulum != "") {
            key += " +(pendulumL:\(pendulum)"
        }
        if (link != "") {
            key += " +(link:\(link)"
        }
        if (linkArrow != "") {
            key += " +(linkArrow:\(linkArrow)"
        }
        if (cardType != "") {
            key += " +(cardType:\(cardType)"
        }
        if (cardType2 != "") {
            key += " +(cardType:\(cardType2)"
        }
        if (effect != "") {
            key += " +(effect:\(effect)"
        }
        searchCommon(key, page, callback)
    }
    
    public class func cardDetail(_ hashid: String, _ callback:@escaping (CardDetail2) -> Void)  {
        
        func parseDetail(_ data: String, _ adjust: String, _ wiki: String) -> CardDetail2 {
            let result = CardDetail2()
            do {
                let json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
                if (json.int("result") == 0) {
                    let obj = json["data"]!>~<
                    result.name = replaceChars(obj.string("name"))
                    result.japname = replaceChars(obj.string("japname"))
                    result.enname = replaceChars(obj.string("enname"))
                    result.cardtype = obj.string("cardtype")
                    result.password = obj.string("password")
                    result.limit = obj.string("limit")
                    result.belongs = obj.string("belongs")
                    result.rare = obj.string("rare")
                    result.pack = replaceChars(obj.string("pack"))
                    result.effect = replaceChars(obj.string("effect"))
                    result.race = obj.string("race")
                    result.element = obj.string("element")
                    result.level = obj.string("level")
                    result.atk = obj.string("atk")
                    result.def = obj.string("def")
                    result.link = obj.string("link")
                    result.linkarrow = replaceLinkArrow(obj.string("linkarrow"))
                    
                    for pkinfo in obj["packs"]!>|< {
                        let info = CardPackInfo2()
                        info.url = pkinfo.string("url")
                        info.name = replaceChars(pkinfo.string("name"))
                        info.date = pkinfo.string("date")
                        info.abbr = pkinfo.string("abbr")
                        info.rare = pkinfo.string("rare")
                        result.packs.append(info)
                    }
                    result.adjust = replaceChars(adjust)
                    result.wiki = replaceChars(wiki)
                    result.imageId = obj.int("imageid")
                }
                
            } catch {
                
            }
            return result
        }
        
        YGORequest2.cardDetailWiki(hashid) { data, adjust, wiki in
            callback(parseDetail(data, adjust, wiki))
        }
        
    }
    
    public class func limit(_ callback:@escaping (Array<LimitInfo2>) -> Void) {
        YGORequest2.limit() { data in
            var result = Array<LimitInfo2>()
            do {
                let json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
                if (json.int("result") == 0) {
                    for obj in json["data"]!>|< {
                        let info = LimitInfo2()
                        info.limit = obj.int("limit")
                        info.color = obj.string("color")
                        info.hashid = obj.string("hashid")
                        info.name = replaceChars(obj.string("name"))
                        result.append(info)
                    }
                }
            } catch {
                
            }
            callback(result)
        }
    }
    
    public class func packageList(_ callback:@escaping (Array<PackageInfo2>) -> Void) {
        YGORequest2.packageList() { data in
            var result = Array<PackageInfo2>()
            do {
                let json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
                if (json.int("result") == 0) {
                    for obj in json["data"]!>|< {
                        let info = PackageInfo2()
                        info.season = obj.string("season")
                        info.url = obj.string("url")
                        info.name = replaceChars(obj.string("name"))
                        info.abbr = obj.string("abbr")
                        result.append(info)
                    }
                }
                
            } catch {
                
            }
            callback(result)
        }
    }
    
    public class func packageDetail(_ url: String, _ callback:@escaping (SearchResult2) -> Void) {
        YGORequest2.packageDetail(url) { data in
            callback(parseSearchResult(data))
        }
    }
    
    public class func hostest(_ callback:@escaping (Hotest2) -> Void) {
        YGORequest2.hotest() { data in
            let result = Hotest2()
            do {
                let json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
                if (json.int("result") == 0) {
                    for obj in json["search"]!>^< {
                        result.search.append(obj)
                    }
                    for obj in json["card"]!>|< {
                        let ci = HotCard2()
                        ci.name = replaceChars(obj.string("name"))
                        ci.hashid = obj.string("hashid")
                        result.card.append(ci)
                    }
                    for obj in json["pack"]!>|< {
                        let pi = HotPack2()
                        pi.name = replaceChars(obj.string("name"))
                        pi.packid = obj.string("packid")
                        result.pack.append(pi)
                    }
                }
            } catch {
                
            }
            callback(result)
        }
    }
    
    private class func replaceChars(_ str: String) -> String {
        if (str == "") {
            return ""
        }
        var str2 = str.replacingOccurrences(of: "&quot;", with: "\"")
        str2 = str2.replacingOccurrences(of: "&#039;", with: "'")
        str2 = str2.replacingOccurrences(of: "&amp;", with: "&")
        str2 = str2.replacingOccurrences(of: "<br />", with: "\n")
        str2 = str2.replacingOccurrences(of: "　", with: "")
        return str2
    }
    
    private class func replaceLinkArrow(_ str: String) -> String {
        if (str == "") {
            return ""
        }
        var str2 = str.replacingOccurrences(of: "1", with: "↙")
        str2 = str2.replacingOccurrences(of: "2", with: "↓")
        str2 = str2.replacingOccurrences(of: "3", with: "↘")
        str2 = str2.replacingOccurrences(of: "4", with: "←")
        str2 = str2.replacingOccurrences(of: "6", with: "→")
        str2 = str2.replacingOccurrences(of: "7", with: "↖")
        str2 = str2.replacingOccurrences(of: "8", with: "↑")
        str2 = str2.replacingOccurrences(of: "9", with: "↗")
        return str2
    }
    
    private class func parseSearchResult(_ jsonString: String) -> SearchResult2 {
        let result = SearchResult2()
        do {
            let json = try JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
            result.page = json["meta"]!>~<.int("cur_page")
            result.pageCount = json["meta"]!>~<.int("total_page")
            for obj in json["cards"]!>|< {
                let info = CardInfo2()
                info.cardid = obj.int("id")
                info.hashid = obj.string("hash_id")
                info.name = replaceChars(obj.string("name_nw"))
                info.japname = replaceChars(obj.string("name_ja"))
                info.enname = replaceChars(obj.string("name_en"))
                info.cardtype = obj.string("type_st")
                result.data.append(info)
            }
        
        } catch {
            
        }
        return result
    }
    
    public class func deckTheme(_ callback: @escaping([DeckTheme]) -> Void) {
        YGORequest2.deckTheme() { data in
            var result = [DeckTheme]()
            do {
                let json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [Any]
                for obj in json>|< {
                    let info = DeckTheme()
                    info.code = obj.string("code")
                    info.name = obj.string("name")
                    result.append(info)
                }
            } catch {
            }
            callback(result)
        }
    }
    public class func deckCategory(_ callback: @escaping([DeckCategory]) -> Void) {
        YGORequest2.deckCategory() { data in
            var result = [DeckCategory]()
            do {
                let json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [Any]
                for obj in json>|< {
                    let info = DeckCategory()
                    info.guid = obj.string("guid")
                    info.name = obj.string("name")
                    result.append(info)
                }
            } catch {
            }
            callback(result)
        }
    }
    
    public class func deckInCategory(_ deckhash: String, _ callback: @escaping([DeckTheme]) -> Void) {
        YGORequest2.deckInCategory(deckhash) { data in
            var result = [DeckTheme]()
            do {
                let json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [Any]
                for obj in json>|< {
                    let info = DeckTheme()
                    info.code = obj.string("code")
                    info.name = obj.string("name")
                    result.append(info)
                }
            } catch {
                
            }
            callback(result)
        }
    }
    
    public class func deckDetail(_ code: String, _ callback: @escaping ([DeckDetail]) -> Void) {
        YGORequest2.deck(code) { data in
            var result = [DeckDetail]()
            do {
                let json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [Any]
                for obj in json>|< {
                    let info = DeckDetail()
                    info.name = obj.string("name")
                    info.image = obj.string("image")
                    for m in obj["monster"]!>|< {
                        info.monster.append(DeckCard(m.int("count"), m.string("name")))
                    }
                    for mt in obj["magictrap"]!>|< {
                        info.magictrap.append(DeckCard(mt.int("count"), mt.string("name")))
                    }
                    for e in obj["extra"]!>|< {
                        info.extra.append(DeckCard(e.int("count"), e.string("name")))
                    }
                    result.append(info)
                }
            } catch {
                
            }
            callback(result)
        }
    }
    
    public class func imageSearch(_ file: String, _ callback:@escaping ([String]) -> Void) {
        YGORequest2.imageSearch(file) { data in
            var result = [String]()
            do {
                let json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
                if (json.int("result") == 0) {
                    for obj in json["imgids"]!>^< {
                        result.append(obj)
                    }
                }
            } catch {
                
            }
            callback(result)
        }
    }
    
    public class func findImageByImageId(_ imgid: String, _ callback: @escaping (String, String) -> Void) {
        YGORequest2.findImageByImageId(imgid) { data in
            var hash = ""
            var name = ""
            do {
                let json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
                if (json.int("result") == 0) {
                    hash = json.string("hash")
                    name = json.string("name")
                }
            } catch {
                
            }
            callback(hash, name)
        }
    }
}
