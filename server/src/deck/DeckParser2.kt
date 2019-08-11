package com.rarnu.ygo.server.deck

import com.rarnu.common.forEach
import org.json.JSONArray

fun String.parseTheme(): String {
    var ret = "["
    try {
        val jarr = JSONArray(this)
        jarr.forEach { _, obj ->
            val data = obj.getJSONObject("data")
            ret += "{\"guid\":\"${data.getString("guid")}\",\"code\":\"${data.getString("shortTitleEn")}\",\"name\":\"${data.getString("titleCn")}\"},"
        }
    } catch (e: Throwable) {

    }
    ret = ret.trimEnd(',')
    ret += "]"
    return ret
}

fun String.parseCategory(): String {
    var ret = "["
    try {
        val jarr = JSONArray(this)
        jarr.forEach { _, obj ->
            val data = obj.getJSONObject("data")
            ret += "{\"guid\":\"${data.getString("guid")}\",\"name\":\"${data.getString("titleCn")}\"},"
        }
    } catch (e: Throwable) {

    }
    ret = ret.trimEnd(',')
    ret += "]"
    return ret
}

fun String.parseInCategory(): String {
    var ret = "["
    var tmp = substring(indexOf("<div id='bookTemplate'"))
    tmp = tmp.substring(0, tmp.indexOf("</td>"))
    val imgTag = "url('imgs/"
    val spanTag = "<span color='White'>"
    while (tmp.contains(imgTag)) {
        tmp = tmp.substring(tmp.indexOf(imgTag) + imgTag.length)
        val code = tmp.substring(0, tmp.indexOf("."))
        if (tmp.contains(spanTag)) {
            tmp = tmp.substring(tmp.indexOf(spanTag) + spanTag.length)
            val name = tmp.substring(0, tmp.indexOf("</span"))
            ret += "{\"code\":\"$code\",\"name\":\"$name\"},"
        }
    }
    ret = ret.trimEnd(',')
    ret += "]"
    return ret
}

fun String.parseDeck(): String {
    var ret = "["
    val galleryTag = "id=\"gallery\">"
    val scriptTag = "<script async src=\"//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js\"></script>"
    var tmp = substring(indexOf(galleryTag) + galleryTag.length)
    tmp = tmp.substring(0, tmp.indexOf(scriptTag))

    val h3Tag = "<h3>"
    val tdTag = "<td valign=\"top\""
    val imgTag = "data-original=\""
    while (tmp.contains(h3Tag)) {
        tmp = tmp.substring(tmp.indexOf(h3Tag) + h3Tag.length)
        val deckName = tmp.substring(0, tmp.indexOf("</h3>")).trim()
        tmp = tmp.substring(tmp.indexOf(tdTag))
        val monster = extractCards(tmp.substring(0, tmp.indexOf("</td>")))
        tmp = tmp.substring(tmp.indexOf("</td>") + 5)
        val magicTrap = extractCards(tmp.substring(0, tmp.indexOf("</td>")))
        tmp = tmp.substring(tmp.indexOf("</td>") + 5)
        val extra = extractCards(tmp.substring(0, tmp.indexOf("</td>")))
        tmp = tmp.substring(tmp.indexOf("</td>") + 5)
        tmp = tmp.substring(tmp.indexOf(imgTag) + imgTag.length)
        val img = tmp.substringBefore("\"").replace("../", "")
        ret += "{\"name\":\"$deckName\",\"monster\":$monster,\"magictrap\":$magicTrap,\"extra\":$extra,\"image\":\"$img\"},"
    }
    ret = ret.trimEnd(',')
    ret += "]"
    return ret
}

private fun extractCards(str: String): String {
    var ret = "["
    val tmp = str.substring(str.indexOf(">") + 1)
    val tarr = tmp.split("<br/>").filter { it.contains("rel='popoverx'") || (!it.contains("<span ") && !it.contains("</span>")) }
    tarr.forEach {
        val s = it.trim()
        if (s != "") {
            if (s.contains("</a>")) {
                val c = s[0]
                var sub = s.substringBeforeLast("</a>")
                sub = sub.substringAfterLast(">")
                ret += "{\"count\":$c,\"name\":\"${sub.trim()}\"},"
            } else {
                val c = s[0]
                ret += "{\"count\":$c,\"name\":\"${s.substring(1).trim()}\"},"
            }
        }
    }
    ret = ret.trimEnd(',')
    ret += "]"
    return ret
}