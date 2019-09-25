package com.rarnu.yugioh

import com.rarnu.common.forEach
import com.rarnu.common.forEachString
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

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
    val packs = mutableListOf<CardPackInfo>()
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
    val data = mutableListOf<CardInfo>()
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
    val search = mutableListOf<String>()
    val card = mutableListOf<HotCard>()
    val pack = mutableListOf<HotPack>()
}

class DeckTheme {
    var code = ""
    var name = ""
}

class DeckCategory {
    var guid = ""
    var name = ""
}

data class DeckCard(val count: Int, val name: String)

class DeckDetail {
    var name = ""
    val monster = mutableListOf<DeckCard>()
    val magictrap = mutableListOf<DeckCard>()
    val extra = mutableListOf<DeckCard>()
    var image = ""
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
                result.data.add(CardInfo().apply {
                    cardid = obj.getInt("id")
                    hashid = obj.getString("hash_id")
                    name = replaceChars(obj.getString("name_nw"))
                    japname = replaceChars(obj.getString("name_ja"))
                    enname = replaceChars(obj.getString("name_en"))
                    cardtype = obj.getString("type_st")
                })
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
        val sarr = data.split("\\\\\\\\")
        val result = CardDetail()
        try {
            val json = JSONObject(sarr[0])
            if (json.getInt("result") == 0) {
                val obj = json.getJSONObject("data")
                result.apply {
                    name = replaceChars(obj.getString("name"))
                    japname = replaceChars(obj.getString("japname"))
                    enname = replaceChars(obj.getString("enname"))
                    cardtype = obj.getString("cardtype")
                    password = obj.getString("password")
                    limit = obj.getString("limit")
                    belongs = obj.getString("belongs")
                    rare = obj.getString("rare")
                    pack = replaceChars(obj.getString("pack"))
                    effect = replaceChars(obj.getString("effect"))
                    race = obj.getString("race")
                    element = obj.getString("element")
                    level = obj.getString("level")
                    atk = obj.getString("atk")
                    def = obj.getString("def")
                    link = obj.getString("link")
                    linkarrow = replaceLinkArrow(obj.getString("linkarrow"))
                    adjust = replaceChars(sarr[1])
                    wiki = replaceChars(sarr[2])
                    imageid = obj.getInt("imageid")
                }
                obj.getJSONArray("packs").forEach { _, pkinfo ->
                    result.packs.add(CardPackInfo().apply {
                        url = pkinfo.getString("url")
                        name = replaceChars(pkinfo.getString("name"))
                        date = pkinfo.getString("date")
                        abbr = pkinfo.getString("abbr")
                        rare = pkinfo.getString("rare")
                    })
                }
            }
        } catch (e: Exception) {

        }
        return result
    }

    fun limit(): List<LimitInfo> {
        val ahtml = YGORequest.limit()
        val result = mutableListOf<LimitInfo>()
        try {
            val json = JSONObject(ahtml)
            if (json.getInt("result") == 0) {
                json.getJSONArray("data").forEach { _, obj ->
                    result.add(LimitInfo().apply {
                        limit = obj.getInt("limit")
                        color = obj.getString("color")
                        hashid = obj.getString("hashid")
                        name = replaceChars(obj.getString("name"))
                    })
                }
            }
        } catch (e: Exception) {

        }
        return result
    }

    fun packageList(): List<PackageInfo> {
        val ahtml = YGORequest.packageList()
        val result = mutableListOf<PackageInfo>()
        try {
            val json = JSONObject(ahtml)
            if (json.getInt("result") == 0) {
                json.getJSONArray("data").forEach { _, obj ->
                    result.add(PackageInfo().apply {
                        season = obj.getString("season")
                        url = obj.getString("url")
                        name = replaceChars(obj.getString("name"))
                        abbr = obj.getString("abbr")
                    })
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
                    result.card.add(HotCard().apply {
                        hashid = obj.getString("hashid")
                        name = replaceChars(obj.getString("name"))
                    })
                }
                json.getJSONArray("pack").forEach { _, obj ->
                    result.pack.add(HotPack().apply {
                        name = replaceChars(obj.getString("name"))
                        packid = obj.getString("packid")
                    })
                }
            }
        } catch (e: Exception) {

        }
        return result
    }

    fun deckTheme(): List<DeckTheme> {
        val result = mutableListOf<DeckTheme>()
        try {
            val data = YGORequest.deckTheme()
            val jarr = JSONArray(data)
            jarr.forEach { _, obj ->
                result.add(DeckTheme().apply {
                    code = obj.getString("code")
                    name = obj.getString("name")
                })
            }
        } catch (th: Throwable) {

        }

        return result

    }

    fun deckCategory(): List<DeckCategory> {
        val result = mutableListOf<DeckCategory>()
        try {
            val data = YGORequest.deckCategory()
            val jarr = JSONArray(data)
            jarr.forEach { _, obj ->
                result.add(DeckCategory().apply {
                    guid = obj.getString("guid")
                    name = obj.getString("name")
                })
            }
        } catch (th: Throwable) {

        }
        return result
    }

    fun deckInCategory(deckhash: String): List<DeckTheme> {
        val result = mutableListOf<DeckTheme>()
        try {
            val data = YGORequest.deckInCategory(deckhash)
            val jarr = JSONArray(data)
            jarr.forEach { _, obj ->
                result.add(DeckTheme().apply {
                    code = obj.getString("code")
                    name = obj.getString("name")
                })
            }
        } catch (th: Throwable) {

        }
        return result
    }

    fun deck(code: String): List<DeckDetail> {
        fun JSONArray.map() = mutableListOf<DeckCard>().apply {
            forEach { _, m -> add(DeckCard(m.getInt("count"), m.getString("name"))) }
        }
        val result = mutableListOf<DeckDetail>()
        try {
            val data = YGORequest.deck(code)
            val jarr = JSONArray(data)
            jarr.forEach { _, obj ->
                result.add(DeckDetail().apply {
                    name = obj.getString("name")
                    image = obj.getString("image")
                    monster.addAll(obj.getJSONArray("monster").map())
                    magictrap.addAll(obj.getJSONArray("magictrap").map())
                    extra.addAll(obj.getJSONArray("extra").map())
                })
            }
        } catch (th: Throwable) {

        }
        return result
    }

    fun imageSearch(file: File): List<String> {
        val result = mutableListOf<String>()
        try {
            val data = YGORequest.imageSearch(file)
            val json = JSONObject(data)
            if (json.getInt("result") == 0) {
                val jarr = json.getJSONArray("imgids")
                jarr.forEachString { _, str -> result.add(str) }
            } 
        } catch(th: Throwable) {

        }
        return result
    }

    fun findCardByImageId(imgid: String): String? {
        var ret: String? = null
        try {
            val data = YGORequest.findCardByImageId(imgid)
            val json = JSONObject(data)
            if (json.getInt("result") == 0) {
                ret = json.getString("hash")
            }
        } catch (th: Throwable) {
        }
        return ret
    }
}
