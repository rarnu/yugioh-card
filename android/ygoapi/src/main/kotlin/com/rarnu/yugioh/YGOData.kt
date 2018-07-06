package com.rarnu.yugioh

import android.util.Log
import org.json.JSONObject

class PackageInfo {
    var season = ""
    var url = ""
    var name = ""
    var abbr = ""
}

class LimitInfo {
    var limit = -1
    var color = ""
    var hashid = ""
    var name = ""
}

class CardPackInfo {
    var url = ""
    var name = ""
    var date = ""
    var abbr = ""
    var rare = ""
}

class CardDetail {
    var name = ""
    var japname = ""
    var enname = ""
    var cardtype = ""
    var password = ""
    var limit = ""
    var belongs = ""
    var rare = ""
    var pack = ""
    var effect = ""
    var race = ""
    var element = ""
    var level = ""
    var atk = ""
    var def = ""
    var link = ""
    val packs = arrayListOf<CardPackInfo>()
    var adjust = ""
    var wiki = ""
}

class CardInfo {
    var cardid = -1
    var hashid = ""
    var name = ""
    var japname = ""
    var enname = ""
    var cardtype = ""
}

class SearchResult {
    val data = arrayListOf<CardInfo>()
    var page = -1
    var pageCount = -1
}

class HotCard {
    var hashid = ""
    var name = ""
}

class HotPack {
    var packid = ""
    var name = ""
}

class Hotest {
    val search = arrayListOf<String>()
    val card = arrayListOf<HotCard>()
    val pack = arrayListOf<HotPack>()
}

object YGOData {

    private fun replaceChars(str: String): String {
        var s = str
        s = s.replace("&quot;", "\"")
        s = s.replace("&#039;", "'")
        s = s.replace("　", "")
        return s
    }

    private fun parseSearchResult(jsonString: String): SearchResult {
        val result = SearchResult()
        try {
            val json = JSONObject(jsonString)
            if (json.getInt("result") == 0) {
                result.page = json.getInt("page")
                result.pageCount = json.getInt("pagecount")
                val jarr = json.getJSONArray("data")
                (0 until jarr.length()).forEach {
                    val obj = jarr.getJSONObject(it)
                    val info = CardInfo()
                    info.cardid = obj.getInt("id")
                    info.hashid = obj.getString("hashid")
                    info.name = replaceChars(obj.getString("name"))
                    info.japname = replaceChars(obj.getString("japname"))
                    info.enname = replaceChars(obj.getString("enname"))
                    info.cardtype = obj.getString("cardtype")
                    result.data.add(info)
                }
            }
        } catch (e: Exception) {

        }

        return result
    }

    fun searchCommon(akey: String, apage: Int): SearchResult {
        val ahtml = YGORequest.search(akey, apage)
        var parsed = ""
        if (ahtml != "") {
            parsed = NativeAPI.parse(ahtml, 0)
        }
        return parseSearchResult(parsed)
    }

    fun searchComplex(
            aname: String,
            ajapname: String,
            aenname: String,
            arace: String,
            aelement: String,
            aatk: String,
            adef: String,
            alevel: String,
            apendulum: String,
            alink: String,
            alinkarrow: String,
            acardtype: String,
            acardtype2: String,
            aeffect: String,
            apage: Int
    ): SearchResult {
        var key = ""
        if (aname != "") key += " +(name:$aname)"
        if (ajapname != "") key += " +(japName:$ajapname)"
        if (aenname != "") key += " +(enName:$aenname)"
        if (arace != "") key += " +(race:$arace)"
        if (aelement != "") key += " +(element:$aelement)"
        if (aatk != "") key += " +(atk:$aatk)"
        if (adef != "") key += " +(def:$adef)"
        if (alevel != "") key += " +(level:$alevel)"
        if (apendulum != "") key += " +(pendulumL:$apendulum)"
        if (alink != "") key += " +(link:$alink)"
        if (alinkarrow != "") key += " +(linkArrow:$alinkarrow)"
        if (acardtype != "") key += " +(cardType:$acardtype)"
        if (acardtype2 != "") key += " +(cardType:$acardtype2)"
        if (aeffect != "") key += " +(effect:$aeffect)"
        return searchCommon(key, apage)
    }

    fun cardDetail(hashid: String): CardDetail {
        val ahtml = YGORequest.cardDetail(hashid)
        val wikiHtml = YGORequest.cardWiki(hashid)
        var parsed = ""
        var adjust = ""
        if (ahtml != "") {
            parsed = NativeAPI.parse(ahtml, 1)
            adjust = NativeAPI.parse(ahtml, 2)
        }
        var wiki = ""
        if (wikiHtml != "") {
            wiki = NativeAPI.parse(wikiHtml, 3)
        }

        val result = CardDetail()
        try {
            val json = JSONObject(parsed)
            if (json.getInt("result") == 0) {
                val obj = json.getJSONObject("data")
                result.name = replaceChars(obj.getString("name"))
                result.japname = replaceChars(obj.getString("japname"))
                result.enname = replaceChars(obj.getString("enname"))
                result.cardtype = obj.getString("cardtype")
                result.password = obj.getString("password")
                result.limit = obj.getString("limit")
                result.belongs = obj.getString("belongs")
                result.rare = obj.getString("rare")
                result.pack = replaceChars(obj.getString("pack"))
                result.effect = replaceChars(obj.getString("effect"))
                result.race = obj.getString("race")
                result.element = obj.getString("element")
                result.level = obj.getString("level")
                result.atk = obj.getString("atk")
                result.def = obj.getString("def")
                result.link = obj.getString("link")
                val jarr = obj.getJSONArray("packs")
                (0 until jarr.length()).forEach {
                    val pkinfo = jarr.getJSONObject(it)
                    val info = CardPackInfo()
                    info.url = pkinfo.getString("url")
                    info.name = replaceChars(pkinfo.getString("name"))
                    info.date = pkinfo.getString("date")
                    info.abbr = pkinfo.getString("abbr")
                    info.rare = pkinfo.getString("rare")
                    result.packs.add(info)
                }
                result.adjust = replaceChars(adjust)
                result.wiki = replaceChars(wiki)
            }
        } catch (e: Exception) {

        }
        return result
    }

    fun limit(): List<LimitInfo> {
        val ahtml = YGORequest.limit()
        var parsed = ""
        if (ahtml != "") {
            parsed = NativeAPI.parse(ahtml, 4)
        }

        val result = arrayListOf<LimitInfo>()
        try {
            val json = JSONObject(parsed)
            if (json.getInt("result") == 0) {
                val jarr = json.getJSONArray("data")
                (0 until jarr.length()).forEach {
                    val obj = jarr.getJSONObject(it)
                    val info = LimitInfo()
                    info.limit = obj.getInt("limit")
                    info.color = obj.getString("color")
                    info.hashid = obj.getString("hashid")
                    info.name = replaceChars(obj.getString("name"))
                    result.add(info)
                }
            }
        } catch (e: Exception) {

        }
        return result
    }

    fun packageList(): List<PackageInfo> {
        val ahtml = YGORequest.packageList()
        var parsed = ""
        if (ahtml != "") {
            parsed = NativeAPI.parse(ahtml, 5)
        }
        val result = arrayListOf<PackageInfo>()
        try {
            val json = JSONObject(parsed)
            if (json.getInt("result") == 0) {
                val jarr = json.getJSONArray("data")
                (0 until jarr.length()).forEach {
                    val obj = jarr.getJSONObject(it)
                    val info = PackageInfo()
                    info.season = obj.getString("season")
                    info.url = obj.getString("url")
                    info.name = replaceChars(obj.getString("name"))
                    info.abbr = obj.getString("abbr")
                    result.add(info)
                }
            }
        } catch (e: Exception) {

        }
        return result
    }

    fun packageDetail(aurl: String): SearchResult {
        val ahtml = YGORequest.packageDetail(aurl)
        var parsed = ""
        if (ahtml != "") {
            parsed = NativeAPI.parse(ahtml, 0)
        }
        return parseSearchResult(parsed)
    }

    fun hotest(): Hotest {
        val ahtml = YGORequest.hotest()
        var parsed = ""
        if (ahtml != "") {
            parsed = NativeAPI.parse(ahtml, 6)
        }
        val result = Hotest()
        try {
            val json = JSONObject(parsed)
            if (json.getInt("result") == 0) {
                val arrSearch = json.getJSONArray("search")
                (0 until arrSearch.length()).forEach {
                    result.search.add(arrSearch.getString(it))
                }
                val arrCard = json.getJSONArray("card")
                (0 until arrCard.length()).forEach {
                    val ci = HotCard()
                    ci.hashid = arrCard.getJSONObject(it).getString("hashid")
                    ci.name = replaceChars(arrCard.getJSONObject(it).getString("name"))
                    result.card.add(ci)
                }
                val arrPack = json.getJSONArray("pack")
                (0 until arrPack.length()).forEach {
                    val pi = HotPack()
                    pi.name = replaceChars(arrPack.getJSONObject(it).getString("name"))
                    pi.packid = arrPack.getJSONObject(it).getString("packid")
                    result.pack.add(pi)
                }
            }
        } catch (e: Exception) {

        }
        return result
    }


}
