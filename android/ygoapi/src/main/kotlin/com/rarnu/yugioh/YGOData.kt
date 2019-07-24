package com.rarnu.yugioh

import android.util.Log
import com.rarnu.common.forEach
import com.rarnu.common.forEachString
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
    var linkarrow = ""
    val packs = arrayListOf<CardPackInfo>()
    var adjust = ""
    var wiki = ""
    var imageid = -1
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

    private fun replaceChars(str: String) = str.replace("&quot;", "\"").replace("&#039;", "'").replace("&amp;", "&").replace("<br />", "\n").replace("　", "")

    private fun replaceLinkArrow(str: String) = str.replace("1", "↙").replace("2", "↓").replace("3", "↘").replace("4", "←").replace("6", "→").replace("7", "↖").replace("8", "↑").replace("9", "↗")

    private fun parseSearchResult(jsonString: String): SearchResult {
        val result = SearchResult()
        try {
            val json = JSONObject(jsonString)
            result.page = json.getJSONObject("meta").getInt("cur_page")
            result.pageCount = json.getJSONObject("meta").getInt("total_page")
            json.getJSONArray("cards").forEach { _, obj ->
                val info = CardInfo()
                info.cardid = obj.getInt("id")
                info.hashid = obj.getString("hash_id")
                info.name = replaceChars(obj.getString("name"))
                info.japname = replaceChars(obj.getString("name_ja"))
                info.enname = replaceChars(obj.getString("name_en"))
                info.cardtype = obj.getString("type_st")
                result.data.add(info)
            }
        } catch (e: Exception) {

        }

        return result
    }

    fun searchCommon(akey: String, apage: Int) = parseSearchResult(YGORequest.search(akey, apage) ?: "")

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
        val data = YGORequest.cardDetail(hashid) ?: ""
        val adjust = YGORequest.cardAdjust(hashid) ?: ""
        val wiki = YGORequest.cardWiki(hashid) ?: ""
        val result = CardDetail()
        try {
            val json = JSONObject(data)
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
                result.linkarrow = replaceLinkArrow(obj.getString("linkarrow"))
                obj.getJSONArray("packs").forEach { _, pkinfo ->
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
                result.imageid = obj.getInt("imageid")
            }
        } catch (e: Exception) {

        }
        return result
    }

    fun limit(): List<LimitInfo> {
        val ahtml = YGORequest.limit()
        val result = arrayListOf<LimitInfo>()
        try {
            val json = JSONObject(ahtml)
            if (json.getInt("result") == 0) {
                json.getJSONArray("data").forEach { _, obj ->
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
        val result = arrayListOf<PackageInfo>()
        try {
            val json = JSONObject(ahtml)
            if (json.getInt("result") == 0) {
                json.getJSONArray("data").forEach { _, obj ->
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

    fun packageDetail(aurl: String) = parseSearchResult(YGORequest.packageDetail(aurl) ?: "")

    fun hotest(): Hotest {
        val ahtml = YGORequest.hotest()
        val result = Hotest()
        try {
            val json = JSONObject(ahtml)
            if (json.getInt("result") == 0) {
                json.getJSONArray("search").forEachString { _, s ->
                    result.search.add(s)
                }
                json.getJSONArray("card").forEach { _, obj ->
                    val ci = HotCard()
                    ci.hashid = obj.getString("hashid")
                    ci.name = replaceChars(obj.getString("name"))
                    result.card.add(ci)
                }
                json.getJSONArray("pack").forEach { _, obj ->
                    val pi = HotPack()
                    pi.name = replaceChars(obj.getString("name"))
                    pi.packid = obj.getString("packid")
                    result.pack.add(pi)
                }
            }
        } catch (e: Exception) {

        }
        return result
    }


}
