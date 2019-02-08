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

public class YGOData2: NSObject {

    public class func searchCommon(_ key: String, _ page: Int, _ callback:@escaping (SearchResult2) -> Void) {
        YGORequest2.search(key, page) { data in
            var parsed = ""
            if (data != "") {
                parsed = YGOCAPI.parse(data, 0)
            }
            let result = parseSearchResult(parsed)
            callback(result)
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
        
        func parseDetail(_ data: String, _ wiki: String) -> CardDetail2 {
            let parsed = YGOCAPI.parse(data, 1)
            let adjust = YGOCAPI.parse(data, 2)
            let wikiparsed = YGOCAPI.parse(wiki, 3)
            let result = CardDetail2()
            do {
                let json = try JSONSerialization.jsonObject(with: parsed.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
                if ((json["result"] as! Int) == 0) {
                    let obj = json["data"] as! Dictionary<String, Any>
                    result.name = replaceChars(obj["name"] as! String)
                    result.japname = replaceChars(obj["japname"] as! String)
                    result.enname = replaceChars(obj["enname"] as! String)
                    result.cardtype = obj["cardtype"] as! String
                    result.password = obj["password"] as! String
                    result.limit = obj["limit"] as! String
                    result.belongs = obj["belongs"] as! String
                    result.rare = obj["rare"] as! String
                    result.pack = replaceChars(obj["pack"] as! String)
                    result.effect = replaceChars(obj["effect"] as! String)
                    result.race = obj["race"] as! String
                    result.element = obj["element"] as! String
                    result.level = obj["level"] as! String
                    result.atk = obj["atk"] as! String
                    result.def = obj["def"] as! String
                    result.link = obj["link"] as! String
                    result.linkarrow = replaceLinkArrow(obj["linkarrow"] as! String)
                    
                    let jarr = obj["packs"] as! Array<Dictionary<String, String>>
                    for pkinfo in jarr {
                        let info = CardPackInfo2()
                        info.url = pkinfo["url"]!
                        info.name = replaceChars(pkinfo["name"]!)
                        info.date = pkinfo["date"]!
                        info.abbr = pkinfo["abbr"]!
                        info.rare = pkinfo["rare"]!
                        result.packs.append(info)
                    }
                    
                    result.adjust = replaceChars(adjust)
                    result.wiki = replaceChars(wikiparsed)
                    result.imageId = (obj["imageid"] as! NSString).integerValue
                }
                
            } catch {
                
            }
            return result
        }
        
        var dataData = YGOCache2.loadCache(hashid, 0)
        var wikiData = YGOCache2.loadCache(hashid, 1)
        if (dataData == "" || wikiData == "") {
            YGORequest2.cardDetailWiki(hashid) { str1, str2 in
                dataData = str1
                wikiData = str2
                YGOCache2.saveCache(hashid, 0, dataData)
                YGOCache2.saveCache(hashid, 1, wikiData)
                callback(parseDetail(dataData, wikiData))
            }
        } else {
            callback(parseDetail(dataData, wikiData))
        }
    }
    
    public class func limit(_ callback:@escaping (Array<LimitInfo2>) -> Void) {
        YGORequest2.limit() { data in
            var parsed = ""
            if (data != "") {
                parsed = YGOCAPI.parse(data, 4)
            }
            var result = Array<LimitInfo2>()
            do {
                let json = try JSONSerialization.jsonObject(with: parsed.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
                if ((json["result"] as! Int) == 0) {
                    let jarr = json["data"] as! Array<Dictionary<String, Any>>
                    for obj in jarr {
                        let info = LimitInfo2()
                        info.limit = obj["limit"] as! Int
                        info.color = obj["color"] as! String
                        info.hashid = obj["hashid"] as! String
                        info.name = replaceChars(obj["name"] as! String)
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
            var parsed = ""
            if (data != "") {
                parsed = YGOCAPI.parse(data, 5)
            }
            var result = Array<PackageInfo2>()
            do {
                let json = try JSONSerialization.jsonObject(with: parsed.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
                if ((json["result"] as! Int) == 0) {
                    let jarr = json["data"] as! Array<Dictionary<String, String>>
                    for obj in jarr {
                        let info = PackageInfo2()
                        info.season = obj["season"]!
                        info.url = obj["url"]!
                        info.name = replaceChars(obj["name"]!)
                        info.abbr = obj["abbr"]!
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
            var parsed = ""
            if (data != "") {
                parsed = YGOCAPI.parse(data, 0)
            }
            let result = parseSearchResult(parsed)
            callback(result)
        }
    }
    
    public class func hostest(_ callback:@escaping (Hotest2) -> Void) {
        YGORequest2.hotest() { data in
            var parsed = ""
            if (data != "") {
                parsed = YGOCAPI.parse(data, 6)
            }
            let result = Hotest2()
            do {
                let json = try JSONSerialization.jsonObject(with: parsed.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
                if ((json["result"] as! Int) == 0) {
                    let arrSearch = json["search"] as! Array<String>
                    for obj in arrSearch {
                        result.search.append(obj)
                    }
                    let arrCard = json["card"] as! Array<Dictionary<String, String>>
                    for obj in arrCard {
                        let ci = HotCard2()
                        ci.name = replaceChars(obj["name"]!)
                        ci.hashid = obj["hashid"]!
                        result.card.append(ci)
                    }
                    let arrPack = json["pack"] as! Array<Dictionary<String, String>>
                    for obj in arrPack {
                        let pi = HotPack2()
                        pi.name = replaceChars(obj["name"]!)
                        pi.packid = obj["packid"]!
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
            if ((json["result"] as! Int) == 0) {
                result.page = json["page"] as! Int
                result.pageCount = json["pagecount"] as! Int
                let jarr = json["data"] as! Array<Dictionary<String, Any>>
                for obj in jarr {
                    let info = CardInfo2()
                    info.cardid = obj["id"] as! Int
                    info.hashid = obj["hashid"] as! String
                    info.name = replaceChars(obj["name"] as! String)
                    info.japname = replaceChars(obj["japname"] as! String)
                    info.enname = replaceChars(obj["enname"] as! String)
                    info.cardtype = obj["cardtype"] as! String
                    result.data.append(info)
                }
            }
        } catch {
            
        }
        return result
    }
    
}
