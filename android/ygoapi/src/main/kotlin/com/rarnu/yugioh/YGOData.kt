package com.rarnu.yugioh

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

object YGOData {
    private fun parseSearchResult(jsonString: String): SearchResult {
        val json = JSONObject(jsonString)
        val result = SearchResult()
        if (json.getInt("result") == 0) {
            result.page = json.getInt("page")
            result.pageCount = json.getInt("pagecount")
            val jarr = json.getJSONArray("data")
            (0 until jarr.length()).forEach {
                val obj = jarr.getJSONObject(it)
                val info = CardInfo()
                info.cardid = obj.getInt("id")
                info.hashid = obj.getString("hashid")
                info.name = obj.getString("name")
                info.japname = obj.getString("japname")
                info.enname = obj.getString("enname")
                info.cardtype = obj.getString("cardtype")
                result.data.add(info)
            }
        }
        return result
    }

    fun searchCommon(akey: String, apage: Int) = parseSearchResult(NativeAPI.parse(YGORequest.search(akey, apage), 0))

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
        val parsed = NativeAPI.parse(ahtml, 1)
        val adjust = NativeAPI.parse(ahtml, 2)
        val wikiHtml = YGORequest.cardWiki(hashid)
        val wiki = NativeAPI.parse(wikiHtml, 3)
        val json = JSONObject(parsed)
        val result = CardDetail()
        if (json.getInt("result") == 0) {
            val obj = json.getJSONObject("data")
            result.name = obj.getString("name")
            result.japname = obj.getString("japname")
            result.enname = obj.getString("enname")
            result.cardtype = obj.getString("cardtype")
            result.password = obj.getString("password")
            result.limit = obj.getString("limit")
            result.belongs = obj.getString("belongs")
            result.rare = obj.getString("rare")
            result.pack = obj.getString("pack")
            result.effect = obj.getString("effect")
            result.race = obj.getString("race")
            result.element = obj.getString("element")
            result.level = obj.getString("level")
            result.atk = obj.getString("atk")
            result.def = obj.getString("def")
            result.link = obj.getString("link")
            val jarr = json.getJSONArray("packs")
            (0 until jarr.length()).forEach {
                val pkinfo = jarr.getJSONObject(it)
                val info = CardPackInfo()
                info.url = pkinfo.getString("url")
                info.name = pkinfo.getString("name")
                info.date = pkinfo.getString("date")
                info.abbr = pkinfo.getString("abbr")
                info.rare = pkinfo.getString("rare")
                result.packs.add(info)
            }
            result.adjust = adjust
            result.wiki = wiki
        }
        return result
    }

    fun limit(): List<LimitInfo> {
        val parsed = NativeAPI.parse(YGORequest.limit(), 4)
        val result = arrayListOf<LimitInfo>()
        val json = JSONObject(parsed)
        if (json.getInt("result") == 0) {
            val jarr = json.getJSONArray("data")
            (0 until jarr.length()).forEach {
                val obj = jarr.getJSONObject(it)
                val info = LimitInfo()
                info.limit = obj.getInt("limit")
                info.color = obj.getString("color")
                info.hashid = obj.getString("hashid")
                info.name = obj.getString("name")
                result.add(info)
            }
        }

        return result
    }

    fun packageList(): List<PackageInfo> {
        val parsed = NativeAPI.parse(YGORequest.packageList(), 5)
        val result = arrayListOf<PackageInfo>()
        val json = JSONObject(parsed)
        if (json.getInt("result") == 0) {
            val jarr = json.getJSONArray("data")
            (0 until jarr.length()).forEach {
                val obj = jarr.getJSONObject(it)
                val info = PackageInfo()
                info.season = obj.getString("season")
                info.url = obj.getString("url")
                info.name = obj.getString("name")
                info.abbr = obj.getString("abbr")
                result.add(info)
            }
        }
        return result
    }

    fun packageDetail(aurl: String) = parseSearchResult(NativeAPI.parse(YGORequest.packageDetail(aurl), 0))

}
