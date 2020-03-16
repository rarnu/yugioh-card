import com.rarnu.common.forEach
import com.rarnu.common.httpGet
import org.json.JSONObject
import java.io.File

private val pages = 1..1012

private val outPages = File("output/pages").apply { if (!exists()) mkdirs() }
private val outCards = File("output/cards").apply { if (!exists()) mkdirs() }
private val outAdjusts = File("output/adjusts").apply { if (!exists()) mkdirs() }
private val outWikis = File("output/wikis").apply { if (!exists()) mkdirs() }

private var pageCount = 0
private var cardCount = 0
private var wikiCount = 0

private const val BASEURL = "https://www.ourocg.cn/card"

private fun getPage(page: Int, callback: (String) -> Unit) = File(outPages, "$page.json").run {
    var json = if (exists()) readText().trim() else ""
    if (json == "") {
        json = httpGet("$BASEURL/list-5/$page")!!.parse0()
        writeText(json)
        callback(json)
        pageCount++
        println("write page => $page")
    } else {
        callback(json)
    }
}

private fun getCardDetail(hashid: String, callback: (String, String) -> Unit) = File(outCards, "$hashid.json").run {
    val fAdjust = File(outAdjusts, "$hashid.txt")
    var json = if (exists()) readText().trim() else ""
    if (json == "" || (json.contains("\"name\":\"\"") && json.contains("\"japname\":\"\"") && json.contains("\"enname\":\"\""))) {
        val ret = httpGet("$BASEURL/$hashid")!!
        json = ret.parse1()
        val adjust = ret.parse2()
        writeText(json)
        fAdjust.writeText(adjust)
        callback(json, adjust)
        cardCount++
        println("write card => $hashid")
    } else {
        callback(json, fAdjust.readText())
    }
}

private fun getCardWiki(hashid: String, callback: (String) -> Unit) = File(outWikis, "$hashid.txt").run {
    var wiki = if (exists()) readText().trim() else ""
    if (wiki == "") {
        wiki = httpGet("$BASEURL/$hashid/wiki")!!.parse3()
        writeText(wiki)
        callback(wiki)
        wikiCount++
        println("write wiki => $hashid")
    } else {
        callback(wiki)
    }
}

fun main() {
    pages.forEach { p ->
        getPage(p) { j ->
            JSONObject(j).getJSONArray("cards").forEach { _, obj ->
                val hashid = obj.getString("hash_id")
                getCardDetail(hashid) { _, _ ->

                }
                getCardWiki(hashid) { _ ->

                }
            }
        }
    }
    println("page count => $pageCount")
    println("card count => $cardCount")
    println("wiki count => $wikiCount")
}