//
//  YGOCAPI.swift
//  YGOAPI2
//
//  Created by rarnu on 2019/2/8.
//  Copyright © 2019 rarnu. All rights reserved.
//

import UIKit

extension String {
    func sub(start: Int) -> String {
        if (self == "") {
            return ""
        }
        if (start == -1) {
            return ""
        }
        var tmp = self
        tmp = String(tmp[tmp.index(tmp.startIndex, offsetBy: start)...])
        return tmp
    }
    
    func sub(start: Int, length: Int) -> String {
        if (self == "") {
            return ""
        }
        if (start == -1 || length == -1) {
            return ""
        }
        var tmp = self
        tmp = String(tmp[tmp.index(tmp.startIndex, offsetBy: start)..<tmp.index(tmp.startIndex, offsetBy: start + length)])
        return tmp
    }
    
    func indexOf(sub: String) -> Int {
        var i = -1
        let r = self.range(of: sub)
        if (r != nil) {
            i = r!.lowerBound.encodedOffset
        }
        return i
    }
    
    func trim() -> String {
        var tmp = self
        tmp = tmp.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return tmp
    }
    
    func trim(c: Array<String>) -> String {
        var tmp = self
        var s = ""
        for ch in c {
            s.append(ch)
        }
        tmp = tmp.trimmingCharacters(in: CharacterSet(charactersIn: s))
        return tmp
    }
    
    func trim(c: String) -> String {
        var tmp = self
        tmp = tmp.trimmingCharacters(in: CharacterSet(charactersIn: c))
        return tmp
    }
    
    func split(by: String) -> Array<String> {
        var arr = Array<String>()
        var tmp = self
        var idx = -1
        while true {
            idx = tmp.indexOf(sub: by)
            if (idx != -1) {
                let t = tmp.sub(start: 0, length: idx)
                arr.append(t)
                tmp = tmp.sub(start: idx + by.count)
            } else {
                arr.append(tmp)
                break
            }
        }
        return arr
    }
}

class HtmlParser: NSObject {
    
    class func getStoredJson(_ ahtml: String) -> String {
        let STORE_BEGIN = "window.__STORE__ ="
        let STORE_END = "</script>"
        var ret = ""
        if (ahtml.contains(STORE_BEGIN)) {
            ret = ahtml.sub(start: ahtml.indexOf(sub: STORE_BEGIN))
            ret = ret.sub(start: 0, length: ret.indexOf(sub: STORE_END))
            ret = ret.replacingOccurrences(of: STORE_BEGIN, with: "")
            ret = ret.trim().trim(c: ";")
            
        }
        return ret
    }
    
    class func getArticle(_ ahtml: String) -> String {
        let ARTICLE_BEGIN = "<article class=\"detail\">"
        let ARTICLE_END = "</article>"
        let HDIV = "</div>"
        let HTABLE = "</table>"
        let HIMGID = "http://ocg.resource.m2v.cn/"
        let H1 = "<div class=\"val el-col-xs-18 el-col-sm-12 el-col-md-14 el-col-sm-pull-8 el-col-md-pull-6\">"
        let H2 = "<div class=\"val el-col-xs-8 el-col-sm-6 el-col-sm-pull-8 el-col-md-6 el-col-md-pull-6\">"
        let H3 = "<div class=\"val el-col-xs-10 el-col-sm-6 el-col-sm-pull-8 el-col-md-8 el-col-md-pull-6\">"
        let H31 = "<div class=\"val el-col-xs-6 el-col-sm-4\">"
        let H32 = "<div class=\"val el-col-xs-18 el-col-sm-4\">"
        let H33 = "<div class=\"val el-col-xs-6 el-col-sm-12\">"
        let H34 = "<div class=\"val el-col-xs-6 el-col-sm-4 el-col-md-6\">"
        let H4 = "<div class=\"val el-col-xs-18 el-col-sm-20\">"
        let H5 = "<div class=\"val el-col-24 effect\">"
        let H6 = "<table style=\"width:100%\" ID=\"pack_table_main\">"
        let H7 = "<div class=\"linkMark-Context visible-xs\"></div>"
        
        let HLINKON = "mark-linkmarker_%d_on"
        let HDIVLINE = "<div class=\"line\"></div>"
        // let HDIVLINE2 = "<div class='line'></div>"
        
        let ESPLIT = "- - - - - -"
        
        var cimgid = ""
        var cname = ""
        var cjapname = ""
        var cenname = ""
        var ccardtype = ""
        var cpassword = ""
        var climit = ""
        var cbelongs = ""
        var crare = ""
        var cpack = ""
        var ceffect = ""
        var crace = ""
        var celement = ""
        var clevel = ""
        var catk = ""
        var cdef = ""
        var clink = ""
        var clinkarrow = ""
        var cpacklist = ""
        if (ahtml.contains(ARTICLE_BEGIN)) {
            var tmp = ahtml.sub(start: ahtml.indexOf(sub: ARTICLE_BEGIN))
            tmp = tmp.sub(start: 0, length: tmp.indexOf(sub: ARTICLE_END))
            tmp = tmp.sub(start: tmp.indexOf(sub: HIMGID) + HIMGID.count)
            cimgid = tmp.sub(start: 0, length: tmp.indexOf(sub: ".")).trim()
            tmp = tmp.sub(start: tmp.indexOf(sub: H1) + H1.count)
            cname = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
            cname = parseTextVersion(cname)
            tmp = tmp.sub(start: tmp.indexOf(sub: H1) + H1.count)
            cjapname = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
            tmp = tmp.sub(start: tmp.indexOf(sub: H1) + H1.count)
            cenname = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
            tmp = tmp.sub(start: tmp.indexOf(sub: H1) + H1.count)
            ccardtype = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim().replacingOccurrences(of: "</span>", with: "|").replacingOccurrences(of: "<span>", with: "")
            let ctarr = ccardtype.split(by: "|")
            ccardtype = ""
            for s in ctarr {
                ccardtype += "\(s.trim()) | "
            }
            ccardtype = ccardtype.trim().trim(c: "|")
            tmp = tmp.sub(start: tmp.indexOf(sub: H1) + H1.count)
            cpassword = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
            tmp = tmp.sub(start: tmp.indexOf(sub: H2) + H2.count)
            climit = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
            tmp = tmp.sub(start: tmp.indexOf(sub: H3) + H3.count)
            cbelongs = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
            
            if (ccardtype.contains("怪兽")) {
                if (ccardtype.contains("连接")) {
                    tmp = tmp.sub(start: tmp.indexOf(sub: H31) + H31.count)
                    crace = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
                    tmp = tmp.sub(start: tmp.indexOf(sub: H31) + H31.count)
                    celement = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
                    tmp = tmp.sub(start: tmp.indexOf(sub: H31) + H31.count)
                    catk = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
                    tmp = tmp.sub(start: tmp.indexOf(sub: H34) + H34.count)
                    clink = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
                    tmp = tmp.sub(start: tmp.indexOf(sub: H7) + H7.count)
                    let tmpArrow = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV))
                    for i in 1...9 {
                        if (tmpArrow.contains(String(format: HLINKON, i))) {
                            clinkarrow += "\(i)"
                        }
                    }
                } else {
                    tmp = tmp.sub(start: tmp.indexOf(sub: H31) + H31.count)
                    crace = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
                    tmp = tmp.sub(start: tmp.indexOf(sub: H31) + H31.count)
                    celement = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
                    tmp = tmp.sub(start: tmp.indexOf(sub: H32) + H32.count)
                    clevel = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
                    tmp = tmp.sub(start: tmp.indexOf(sub: H31) + H31.count)
                    catk = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
                    tmp = tmp.sub(start: tmp.indexOf(sub: H33) + H33.count)
                    cdef = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
                }
            }
            
            tmp = tmp.sub(start: tmp.indexOf(sub: H4) + H4.count)
            crare = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
            if (crare.contains(">")) {
                crare = ""
            }
            tmp = tmp.sub(start: tmp.indexOf(sub: H4) + H4.count)
            cpack = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim()
            if (cpack.contains(">")) {
                cpack = ""
            }
            tmp = tmp.sub(start: tmp.indexOf(sub: H5) + H5.count).replacingOccurrences(of: HDIVLINE, with: ESPLIT).replacingOccurrences(of: "<br>", with: "")
            ceffect = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIV)).trim().replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
            ceffect = parseTextVersion(ceffect)
            tmp = tmp.sub(start: tmp.indexOf(sub: H6) + H6.count)
            tmp = tmp.sub(start: 0, length: tmp.indexOf(sub: HTABLE)).trim()
            cpacklist = getPackList(tmp)
        }
        let ret = "{\"result\":0, \"data\":{\"name\":\"\(cname)\",\"japname\":\"\(cjapname)\",\"enname\":\"\(cenname)\",\"cardtype\":\"\(ccardtype)\",\"password\":\"\(cpassword)\",\"limit\":\"\(climit)\",\"belongs\":\"\(cbelongs)\",\"rare\":\"\(crare)\",\"pack\":\"\(cpack)\",\"effect\":\"\(ceffect)\",\"race\":\"\(crace)\",\"element\":\"\(celement)\",\"level\":\"\(clevel)\",\"atk\":\"\(catk)\",\"def\":\"\(cdef)\",\"link\":\"\(clink)\",\"linkarrow\":\"\(clinkarrow)\",\"imageid\":\"\(cimgid)\",\"packs\":[\(cpacklist)]}}"
        return ret
    }
    
    class func getLimitList(_ ahtml: String) -> String {
        let HTABLE = "<table class=\"deckDetail\">"
        let HTABLEEND = "</table>"
        let HCARD = "<td class=\"cname\"><div class=\"typeIcon\" style=\"border-color:"
        let HREFID = "https://www.ourocg.cn/card/"
        let HTARGET = "target=_blank>"
        let HAEND = "</a>"
        let HTBODY = "<tbody>"
        var ret = "{\"result\":0, \"data\":["
        if (ahtml.contains(HTABLE)) {
            var tmp = ahtml.sub(start: ahtml.indexOf(sub: HTABLE))
            tmp = tmp.sub(start: 0, length: tmp.indexOf(sub: HTABLEEND))
            tmp = tmp.sub(start: tmp.indexOf(sub: HTBODY) + HTBODY.count).trim()
            let strarr = tmp.split(by: HTBODY)
            
            for i in strarr.indices {
                var stmp = strarr[i]
                while true {
                    if (!stmp.contains(HCARD)) {
                        break
                    }
                    ret += "{\"limit\":\(i),"
                    stmp = stmp.sub(start: stmp.indexOf(sub: HCARD) + HCARD.count).trim()
                    ret += "\"color\":\"\(stmp.sub(start: 0, length: stmp.indexOf(sub: "\"")).trim())\","
                    stmp = stmp.sub(start: stmp.indexOf(sub: HREFID) + HREFID.count).trim()
                    ret += "\"hashid\":\"\(stmp.sub(start: 0, length: stmp.indexOf(sub: "\"")).trim())\","
                    stmp = stmp.sub(start: stmp.indexOf(sub: HTARGET) + HTARGET.count).trim()
                    ret += "\"name\":\"\(stmp.sub(start: 0, length: stmp.indexOf(sub: HAEND)).trim())\"},"
                }
            }
        }
        ret = ret.trim(c: ",")
        ret += "]}"
        return ret
    }
    
    class func getPackageList(_ ahtml: String) -> String {
        let HDIV = "<div class=\"package-view package-list\">"
        let HSIDE = "<div class=\"sidebar-wrapper\">"
        let HH2 = "<h2>"
        let HH2END = "</h2>"
        let HLIREF = "<li><a href=\""
        let HAEND = "</a>"
        var ret = "{\"result\":0, \"data\":["
        var tmp = ahtml.sub(start: ahtml.indexOf(sub: HDIV) + HDIV.count)
        tmp = tmp.sub(start: 0, length: tmp.indexOf(sub: HSIDE)).trim()
        tmp = tmp.sub(start: tmp.indexOf(sub: HH2) + HH2.count)
        let strarr = tmp.split(by: HH2)
        for s in strarr {
            var stmp = s
            let season = stmp.sub(start: 0, length: stmp.indexOf(sub: HH2END)).trim()
            while true {
                if (!stmp.contains(HLIREF)) {
                    break
                }
                ret += "{\"season\":\"\(season)\","
                stmp = stmp.sub(start: stmp.indexOf(sub: HLIREF) + HLIREF.count).trim()
                ret += "\"url\":\"\(stmp.sub(start: 0, length: stmp.indexOf(sub: "\"")).trim())\","
                stmp = stmp.sub(start: stmp.indexOf(sub: ">") + 1)
                var namestr = stmp.sub(start: 0, length: stmp.indexOf(sub: HAEND)).trim()
                if (namestr.contains("(")) {
                    ret += "\"name\":\"\(namestr.sub(start: 0, length: namestr.indexOf(sub: "(")).trim())\","
                    namestr = namestr.sub(start: namestr.indexOf(sub: "(") + 1)
                    ret += "\"abbr\":\"\(namestr.sub(start: 0, length: namestr.indexOf(sub: ")")).trim())\"},"
                } else {
                    ret += "\"name\":\"\(namestr.trim())\",\"abbr\":\"\"},"
                }
            }
        }
        ret = ret.trim(c: ",")
        ret += "]}"
        return ret
    }
    
    class func getHotest(_ ahtml: String) -> String {
        let HSEARCH = "<h3>热门搜索</h3>"
        let HULEND = "</ul>"
        let HSEARCHITEM = "<li class=\"el-button el-button--info is-plain el-button--small\"><a href=\""
        let HAEND = "</a>"
        let HCARD = "<h3 class=\"no-underline\">热门卡片</h3>"
        let HCARDITEM = "<li><a href=\"/card/"
        let HPACK = "<h3 class=\"no-underline\">热门卡包"
        let HPACKITEM = "<li><a href=\""
        
        var strSearch = ""
        var strCard = ""
        var strPackage = ""
        
        // hot search
        var htmlSearch = ahtml.sub(start: ahtml.indexOf(sub: HSEARCH) + HSEARCH.count)
        htmlSearch = htmlSearch.sub(start: 0, length: htmlSearch.indexOf(sub: HULEND)).trim()
        while true {
            if (!htmlSearch.contains(HSEARCHITEM)) {
                break
            }
            htmlSearch = htmlSearch.sub(start: htmlSearch.indexOf(sub: HSEARCHITEM) + HSEARCHITEM.count).trim()
            htmlSearch = htmlSearch.sub(start: htmlSearch.indexOf(sub: ">") + 1).trim()
            strSearch += "\"\(htmlSearch.sub(start: 0, length: htmlSearch.indexOf(sub: HAEND)).trim())\","
        }
        strSearch = strSearch.trim(c: ",")
        // hot card
        var htmlCard = ahtml.sub(start: ahtml.indexOf(sub: HCARD) + HCARD.count)
        htmlCard = htmlCard.sub(start: 0, length: htmlCard.indexOf(sub: HULEND)).trim()
        while true {
            if (!htmlCard.contains(HCARDITEM)) {
                break
            }
            htmlCard = htmlCard.sub(start: htmlCard.indexOf(sub: HCARDITEM) + HCARDITEM.count).trim()
            strCard += "{\"hashid\":\"\(htmlCard.sub(start: 0, length: htmlCard.indexOf(sub: "\"")).trim())\","
            htmlCard = htmlCard.sub(start: htmlCard.indexOf(sub: ">") + 1)
            strCard += "\"name\":\"\(htmlCard.sub(start: 0, length: htmlCard.indexOf(sub: HAEND)).trim())\"},"
        }
        strCard = strCard.trim(c: ",")
        
        // hot package
        var htmlPack = ahtml.sub(start: ahtml.indexOf(sub: HPACK) + HPACK.count)
        htmlPack = htmlPack.sub(start: 0, length: htmlPack.indexOf(sub: HULEND)).trim()
        while true {
            if (!htmlPack.contains(HPACKITEM)) {
                break
            }
            htmlPack = htmlPack.sub(start: htmlPack.indexOf(sub: HPACKITEM) + HPACKITEM.count).trim()
            strPackage += "{\"packid\":\"\(htmlPack.sub(start: 0, length: htmlPack.indexOf(sub: "\"")).trim())\","
            htmlPack = htmlPack.sub(start: htmlPack.indexOf(sub: ">") + 1).trim()
            strPackage += "\"name\":\"\(htmlPack.sub(start: 0, length: htmlPack.indexOf(sub: HAEND)).trim())\"},"
        }
        strPackage = strPackage.trim(c: ",")
        let ret = "{\"result\":0, \"search\":[\(strSearch)], \"card\":[\(strCard)], \"pack\":[\(strPackage)]}"
        return ret
    }
    
    class func getAdjust(_ ahtml: String) -> String {
        let ARTICLE_BEGIN = "<article class=\"detail\">"
        let ARTICLE_END = "</article>"
        let ADJUST_BEGIN = "<div class=\"wiki\" ID=\"adjust\">"
        let HSTRONG = "</strong>"
        let HLI = "</li><li>"
        let HLIEND = "</li>"
        var ret = ""
        if (ahtml.contains(ARTICLE_BEGIN)) {
            var tmp = ahtml.sub(start: ahtml.indexOf(sub: ARTICLE_BEGIN))
            tmp = tmp.sub(start: 0, length: tmp.indexOf(sub: ARTICLE_END))
            if (tmp.contains(ADJUST_BEGIN)) {
                tmp = tmp.sub(start: tmp.indexOf(sub: ADJUST_BEGIN))
                tmp = tmp.sub(start: tmp.indexOf(sub: HSTRONG) + HSTRONG.count)
                tmp = tmp.sub(start: tmp.indexOf(sub: HLI) + HLI.count)
                tmp = tmp.sub(start: 0, length: tmp.indexOf(sub: HLIEND)).trim()
                tmp = tmp.replacingOccurrences(of: "<br />", with: "")
                tmp = tmp.replacingOccurrences(of: "&lt;", with: "<").replacingOccurrences(of: "&gt;", with: ">")
                ret = tmp
            }
        }
        return ret
    }
    class func getWiki(_ ahtml: String) -> String {
        let HPREEND = "</pre>"
        let HDIVEND = "</div>"
        var ret = ""
        if (ahtml.contains(HPREEND)) {
            var tmp = ahtml.sub(start: ahtml.indexOf(sub: HPREEND) + HPREEND.count)
            tmp = tmp.sub(start: 0, length: tmp.indexOf(sub: HDIVEND)).trim()
            ret = tmp
        }
        return ret
    }
    
    private class func getPackList(_ ahtml: String) -> String {
        let HTR = "<tr></tr>"
        let HHREF = "<tr><td><a href=\""
        let HSMALL = "<small>"
        let HSMALLEND = "</small>"
        let HTD = "<td>"
        let HTDEND = "</td>"
        var ret = ""
        var tmp = ahtml.sub(start: ahtml.indexOf(sub: HTR) + HTR.count).trim()
        while true {
            if (!tmp.contains(HHREF)) {
                break
            }
            ret += "{"
            tmp = tmp.sub(start: tmp.indexOf(sub: HHREF) + HHREF.count)
            ret += "\"url\":\"\(tmp.sub(start: 0, length: tmp.indexOf(sub: "\"")).trim())\","
            tmp = tmp.sub(start: tmp.indexOf(sub: ">") + 1)
            ret += "\"name\":\"\(tmp.sub(start: 0, length: tmp.indexOf(sub: "</a>")).trim())\","
            tmp = tmp.sub(start: tmp.indexOf(sub: HSMALL) + HSMALL.count)
            ret += "\"date\":\"\(tmp.sub(start: 0, length: tmp.indexOf(sub: HSMALLEND)).trim())\","
            tmp = tmp.sub(start: tmp.indexOf(sub: HTD) + HTD.count)
            ret += "\"abbr\":\"\(tmp.sub(start: 0, length: tmp.indexOf(sub: HTDEND)).trim())\","
            tmp = tmp.sub(start: tmp.indexOf(sub: HTD) + HTD.count)
            ret += "\"rare\":\"\(tmp.sub(start: 0, length: tmp.indexOf(sub: HTDEND)).trim())\""
            ret += "},"
        }
        ret = ret.trim(c: ",")
        return ret
    }
    
    private class func parseTextVersion(_ astr: String) -> String {
        var ret = astr
        if (ret.contains("<template")) {
            ret = ret.sub(start: ret.indexOf(sub: "<template"))
            ret = ret.replacingOccurrences(of: "<template v-if=\"text_version == 'cn'\" >", with: "")
            ret = ret.replacingOccurrences(of: "<template v-if=\"text_version == 'cn'\">", with: "")
            ret = ret.sub(start: 0, length: ret.indexOf(sub: "</template>")).trim()
        }
        return ret
    }
    
}

class SearchResult: NSObject {
    class func parseSearchResult(_ ajsonstr: String) -> String {
        var ret = "{\"result\":0, \"data\":["
        var page = 0
        var pageCount = 0
        do {
            let json = try JSONSerialization.jsonObject(with: ajsonstr.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, Any>
            let meta = json["meta"] as! Dictionary<String, Any>
            page = meta["cur_page"] as! Int
            pageCount = meta["total_page"] as! Int
            let jarr = json["cards"] as! Array<Dictionary<String, Any>>
            for obj in jarr {
                let acnname = (obj["name"] as! String).replacingOccurrences(of: "\"", with: "\\\"")
                let ajapname = obj["name_ja"] is NSNull ? "" : (obj["name_ja"] as! String).replacingOccurrences(of: "\"", with: "\\\"")
                let aenname = obj["name_en"] is NSNull ? "" : (obj["name_en"] as! String).replacingOccurrences(of: "\"", with: "\\\"")
                let _typ = type(of: obj["id"]!)
                var cid = ""
                if ("\(_typ)".contains("String")) {
                    cid = obj["id"] as! String
                } else {
                    cid = "\(obj["id"] as! Int)"
                }
                ret += "{\"id\":\(cid),\"hashid\":\"\(obj["hash_id"] as! String)\",\"name\":\"\(acnname)\",\"japname\":\"\(ajapname)\",\"enname\":\"\(aenname)\",\"cardtype\":\"\(obj["type_st"] as! String)\"},"
            }
            
        } catch {
            
        }
        ret = ret.trim(c: ",")
        ret += "],"
        ret += "\"page\":\(page),\"pagecount\":\(pageCount)}"
        return ret
    }
}

public class YGOCAPI: NSObject {
    
    public class func parse(_ ahtml: String, _ atype: Int) -> String {
        var ret = ""
        switch atype{
        case 0:
            let jsonstr = HtmlParser.getStoredJson(ahtml)
            ret = SearchResult.parseSearchResult(jsonstr)
            break
        case 1:
            ret = HtmlParser.getArticle(ahtml)
            break
        case 2:
            ret = HtmlParser.getAdjust(ahtml)
            break
        case 3:
            ret = HtmlParser.getWiki(ahtml)
            break
        case 4:
            ret = HtmlParser.getLimitList(ahtml)
            break
        case 5:
            ret = HtmlParser.getPackageList(ahtml)
            break
        case 6:
            ret = HtmlParser.getHotest(ahtml)
            break
        default:
            break
        }
        return ret
    }
}
