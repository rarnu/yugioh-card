@file:Suppress("LocalVariableName", "DuplicatedCode", "UnnecessaryVariable")

package com.rarnu.ygo.server.card

// getStoredJson
fun String.parse0() = getStoredJson(this)

// getArticle
fun String.parse1() = getArticle(this)

// getAdjust
fun String.parse2() = getAdjust(this)

// getWiki
fun String.parse3() = getWiki(this)

// getLimitList
fun String.parse4() = getLimitList(this)

// getPackageList
fun String.parse5() = getPackageList(this)

// getHotest
fun String.parse6() = getHotest(this)

private fun getStoredJson(ahtml: String): String {
    val storeBegin = "window.__STORE__ ="
    val storeEnd = "</script>"
    var ret = ""
    if (ahtml.contains(storeBegin)) {
        ret = ahtml.substring(ahtml.indexOf(storeBegin))
        ret = ret.substring(0, ret.indexOf(storeEnd))
        ret = ret.replace(storeBegin, "")
        ret = ret.trim().trim(';')
    }
    return ret
}

private fun getArticle(ahtml: String): String {
    val ARTICLE_BEGIN = "<article class=\"detail\">"
    val ARTICLE_END = "</article>"
    val HDIV = "</div>"
    val HTABLE = "</table>"
    val HIMGID = "http://ocg.resource.m2v.cn/"
    val H1 = "<div class=\"val el-col-xs-18 el-col-sm-12 el-col-md-14 el-col-sm-pull-8 el-col-md-pull-6\">"
    val H2 = "<div class=\"val el-col-xs-8 el-col-sm-6 el-col-sm-pull-8 el-col-md-6 el-col-md-pull-6\">"
    val H3 = "<div class=\"val el-col-xs-10 el-col-sm-6 el-col-sm-pull-8 el-col-md-8 el-col-md-pull-6\">"
    val H31 = "<div class=\"val el-col-xs-6 el-col-sm-4\">"
    val H32 = "<div class=\"val el-col-xs-18 el-col-sm-4\">"
    val H33 = "<div class=\"val el-col-xs-6 el-col-sm-12\">"
    val H34 = "<div class=\"val el-col-xs-6 el-col-sm-4 el-col-md-6\">"
    val H4 = "<div class=\"val el-col-xs-18 el-col-sm-20\">"
    val H5 = "<div class=\"val el-col-24 effect\">"
    val H6 = "<table style=\"width:100%\" ID=\"pack_table_main\">"
    val H7 = "<div class=\"linkMark-Context visible-xs\"></div>"

    val HLINKON = "mark-linkmarker_%d_on"
    val HDIVLINE = "<div class=\"line\"></div>"

    val ESPLIT = "- - - - - -"

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
        var tmp = ahtml.substring(ahtml.indexOf(ARTICLE_BEGIN))
        tmp = tmp.substring(0, tmp.indexOf(ARTICLE_END))
        tmp = tmp.substring(tmp.indexOf(HIMGID) + HIMGID.length)
        cimgid = tmp.substring(0, tmp.indexOf(".")).trim()
        tmp = tmp.substring(tmp.indexOf(H1) + H1.length)
        cname = tmp.substring(0, tmp.indexOf(HDIV)).trim()
        cname = parseTextVersion(cname)
        tmp = tmp.substring(tmp.indexOf(H1) + H1.length)
        cjapname = tmp.substring(0, tmp.indexOf(HDIV)).trim()
        tmp = tmp.substring(tmp.indexOf(H1) + H1.length)
        cenname = tmp.substring(0, tmp.indexOf(HDIV)).trim()
        tmp = tmp.substring(tmp.indexOf(H1) + H1.length)
        ccardtype = tmp.substring(0, tmp.indexOf(HDIV)).trim().replace("</span>", "|").replace("<span>", "")
        val ctarr = ccardtype.split("|")
        ccardtype = ""
        for (s in ctarr) {
            ccardtype += "${s.trim()} | "
        }
        ccardtype = ccardtype.trim().trim('|')
        tmp = tmp.substring(tmp.indexOf(H1) + H1.length)
        cpassword = tmp.substring(0, tmp.indexOf(HDIV)).trim()
        tmp = tmp.substring(tmp.indexOf(H2) + H2.length)
        climit = tmp.substring(0, tmp.indexOf(HDIV)).trim()
        tmp = tmp.substring(tmp.indexOf(H3) + H3.length)
        cbelongs = tmp.substring(0, tmp.indexOf(HDIV)).trim()

        if (ccardtype.contains("怪兽")) {
            if (ccardtype.contains("连接")) {
                tmp = tmp.substring(tmp.indexOf(H31) + H31.length)
                crace = tmp.substring(0, tmp.indexOf(HDIV)).trim()
                tmp = tmp.substring(tmp.indexOf(H31) + H31.length)
                celement = tmp.substring(0, tmp.indexOf(HDIV)).trim()
                tmp = tmp.substring(tmp.indexOf(H31) + H31.length)
                catk = tmp.substring(0, tmp.indexOf(HDIV)).trim()
                tmp = tmp.substring(tmp.indexOf(H34) + H34.length)
                clink = tmp.substring(0, tmp.indexOf(HDIV)).trim()
                tmp = tmp.substring(tmp.indexOf(H7) + H7.length)
                val tmpArrow = tmp.substring(0, tmp.indexOf(HDIV))
                for (i in 1..9) {
                    if (tmpArrow.contains(HLINKON.format(i))) {
                        clinkarrow += "$i"
                    }
                }
            } else {
                tmp = tmp.substring(tmp.indexOf(H31) + H31.length)
                crace = tmp.substring(0, tmp.indexOf(HDIV)).trim()
                tmp = tmp.substring(tmp.indexOf(H31) + H31.length)
                celement = tmp.substring(0, tmp.indexOf(HDIV)).trim()
                tmp = tmp.substring(tmp.indexOf(H32) + H32.length)
                clevel = tmp.substring(0, tmp.indexOf(HDIV)).trim()
                tmp = tmp.substring(tmp.indexOf(H31) + H31.length)
                catk = tmp.substring(0, tmp.indexOf(HDIV)).trim()
                tmp = tmp.substring(tmp.indexOf(H33) + H33.length)
                cdef = tmp.substring(0, tmp.indexOf(HDIV)).trim()
            }
        }

        tmp = tmp.substring(tmp.indexOf(H4) + H4.length)
        crare = tmp.substring(0, tmp.indexOf(HDIV)).trim()
        if (crare.contains(">")) {
            crare = ""
        }
        tmp = tmp.substring(tmp.indexOf(H4) + H4.length)
        cpack = tmp.substring(0, tmp.indexOf(HDIV)).trim()
        if (cpack.contains(">")) {
            cpack = ""
        }
        tmp = tmp.substring(tmp.indexOf(H5) + H5.length).replace(HDIVLINE, ESPLIT).replace("<br>", "")
        ceffect = tmp.substring(0, tmp.indexOf("</template>"/*HDIV*/)).trim().replace("\n", "").replace("\r", "")
        ceffect = parseTextVersion(ceffect)
        tmp = tmp.substring(tmp.indexOf(H6) + H6.length)
        tmp = tmp.substring(0, tmp.indexOf(HTABLE)).trim()
        cpacklist = getPackList(tmp)
    }
    val ret = "{\"result\":0, \"data\":{\"name\":\"$cname\",\"japname\":\"$cjapname\",\"enname\":\"$cenname\",\"cardtype\":\"$ccardtype\",\"password\":\"$cpassword\",\"limit\":\"$climit\",\"belongs\":\"$cbelongs\",\"rare\":\"$crare\",\"pack\":\"$cpack\",\"effect\":\"$ceffect\",\"race\":\"$crace\",\"element\":\"$celement\",\"level\":\"$clevel\",\"atk\":\"$catk\",\"def\":\"$cdef\",\"link\":\"$clink\",\"linkarrow\":\"$clinkarrow\",\"imageid\":\"$cimgid\",\"packs\":[$cpacklist]}}"
    return ret
}

private fun parseTextVersion(astr: String): String {
    var ret = astr
    if (ret.contains("<template")) {
        ret = ret.substring(ret.indexOf("<template"))
        ret = ret.replace("<template v-if=\"text_version == 'cn'\" >", "")
        ret = ret.replace("<template v-if=\"text_version == 'cn'\">", "")
        if (ret.contains("</template>")) {
            ret = ret.substring(0, ret.indexOf("</template>"))
        }
        ret = ret.replace("<div class='line'></div>", "- - - - - -")
        ret = ret.trim()
    }
    return ret
}

private fun getPackList(ahtml: String): String {
    val HTR = "<tr></tr>"
    val HHREF = "<tr><td><a href=\""
    val HSMALL = "<small>"
    val HSMALLEND = "</small>"
    val HTD = "<td>"
    val HTDEND = "</td>"
    var ret = ""
    var tmp = ahtml.substring(ahtml.indexOf(HTR) + HTR.length).trim()
    while (true) {
        if (!tmp.contains(HHREF)) {
            break
        }
        ret += "{"
        tmp = tmp.substring(tmp.indexOf(HHREF) + HHREF.length)
        ret += "\"url\":\"${tmp.substring(0, tmp.indexOf("\"")).trim()}\","
        tmp = tmp.substring(tmp.indexOf(">") + 1)
        ret += "\"name\":\"${tmp.substring(0, tmp.indexOf("</a>")).trim()}\","
        tmp = tmp.substring(tmp.indexOf(HSMALL) + HSMALL.length)
        ret += "\"date\":\"${tmp.substring(0, tmp.indexOf(HSMALLEND)).trim()}\","
        tmp = tmp.substring(tmp.indexOf(HTD) + HTD.length)
        ret += "\"abbr\":\"${tmp.substring(0, tmp.indexOf(HTDEND)).trim()}\","
        tmp = tmp.substring(tmp.indexOf(HTD) + HTD.length)
        ret += "\"rare\":\"${tmp.substring(0, tmp.indexOf(HTDEND)).trim()}\""
        ret += "},"
    }
    ret = ret.trim(',')
    return ret
}


private fun getAdjust(ahtml: String) = try {
    val ARTICLE_BEGIN = "<article class=\"detail\">"
    val ARTICLE_END = "</article>"
    val ADJUST_BEGIN = "<div class=\"wiki\" ID=\"adjust\">"
    val HSTRONG = "</strong>"
    val HLI = "</li><li>"
    val HLIEND = "</li>"
    var ret = ""
    if (ahtml.contains(ARTICLE_BEGIN)) {
        var tmp = ahtml.substring(ahtml.indexOf(ARTICLE_BEGIN))
        tmp = tmp.substring(0, tmp.indexOf(ARTICLE_END))
        if (tmp.contains(ADJUST_BEGIN)) {
            tmp = tmp.substring(tmp.indexOf(ADJUST_BEGIN))
            tmp = tmp.substring(tmp.indexOf(HSTRONG) + HSTRONG.length)
            tmp = tmp.substring(tmp.indexOf(HLI) + HLI.length)
            tmp = tmp.substring(0, tmp.indexOf(HLIEND)).trim()
            tmp = tmp.replace("<br />", "")
            tmp = tmp.replace("&lt;", "<").replace("&gt;", ">")
            ret = tmp
        }
    }
    ret
} catch (th: Throwable) {
    ""
}

private fun getWiki(ahtml: String): String {
    val HPREEND = "</pre>"
    val HDIVEND = "</div>"
    var ret = ""
    if (ahtml.contains(HPREEND)) {
        var tmp = ahtml.substring(ahtml.indexOf(HPREEND) + HPREEND.length)
        tmp = tmp.substring(0, tmp.indexOf(HDIVEND)).trim()
        ret = tmp
    }
    return ret
}

private fun getLimitList(ahtml: String): String {
    val HTABLE = "<table class=\"deckDetail\">"
    val HTABLEEND = "</table>"
    val HCARD = "<td class=\"cname\"><div class=\"typeIcon\" style=\"border-color:"
    val HREFID = "https://www.ourocg.cn/card/"
    val HTARGET = "target=_blank>"
    val HAEND = "</a>"
    val HTBODY = "<tbody>"
    var ret = "{\"result\":0, \"data\":["
    if (ahtml.contains(HTABLE)) {
        var tmp = ahtml.substring(ahtml.indexOf(HTABLE))
        tmp = tmp.substring(0, tmp.indexOf(HTABLEEND))
        tmp = tmp.substring(tmp.indexOf(HTBODY) + HTBODY.length).trim()
        val strarr = tmp.split(HTBODY)

        for (i in strarr.indices) {
            var stmp = strarr[i]
            while (true) {
                if (!stmp.contains(HCARD)) {
                    break
                }
                ret += "{\"limit\":$i,"
                stmp = stmp.substring(stmp.indexOf(HCARD) + HCARD.length).trim()
                ret += "\"color\":\"${stmp.substring(0, stmp.indexOf("\"")).trim()}\","
                stmp = stmp.substring(stmp.indexOf(HREFID) + HREFID.length).trim()
                ret += "\"hashid\":\"${stmp.substring(0, stmp.indexOf("\"")).trim()}\","
                stmp = stmp.substring(stmp.indexOf(HTARGET) + HTARGET.length).trim()
                ret += "\"name\":\"${stmp.substring(0, stmp.indexOf(HAEND)).trim()}\"},"
            }
        }
    }
    ret = ret.trim(',')
    ret += "]}"
    return ret
}

private fun getPackageList(ahtml: String): String {
    val HDIV = "<div class=\"package-view package-list\">"
    val HSIDE = "<div class=\"sidebar-wrapper\">"
    val HH2 = "<h2>"
    val HH2END = "</h2>"
    val HLIREF = "<li><a href=\""
    val HAEND = "</a>"
    var ret = "{\"result\":0, \"data\":["
    var tmp = ahtml.substring(ahtml.indexOf(HDIV) + HDIV.length)
    tmp = tmp.substring(0, tmp.indexOf(HSIDE)).trim()
    tmp = tmp.substring(tmp.indexOf(HH2) + HH2.length)
    val strarr = tmp.split(HH2)
    for (s in strarr) {
        var stmp = s
        val season = stmp.substring(0, stmp.indexOf(HH2END)).trim()
        while (true) {
            if (!stmp.contains(HLIREF)) {
                break
            }
            ret += "{\"season\":\"$season\","
            stmp = stmp.substring(stmp.indexOf(HLIREF) + HLIREF.length).trim()
            ret += "\"url\":\"${stmp.substring(0, stmp.indexOf("\"")).trim()}\","
            stmp = stmp.substring(stmp.indexOf(">") + 1)
            var namestr = stmp.substring(0, stmp.indexOf(HAEND)).trim()
            if (namestr.contains("(")) {
                ret += "\"name\":\"${namestr.substring(0, namestr.indexOf("(")).trim()}\","
                namestr = namestr.substring(namestr.indexOf("(") + 1)
                ret += "\"abbr\":\"${namestr.substring(0, namestr.indexOf(")")).trim()}\"},"
            } else {
                ret += "\"name\":\"${namestr.trim()}\",\"abbr\":\"\"},"
            }
        }
    }
    ret = ret.trim(',')
    ret += "]}"
    return ret
}

private fun getHotest(ahtml: String): String {
    val HSEARCH = "<h3>热门搜索</h3>"
    val HULEND = "</ul>"
    val HSEARCHITEM = "<li class=\"el-button el-button--info is-plain el-button--small\"><a href=\""
    val HAEND = "</a>"
    val HCARD = "<h3 class=\"no-underline\">热门卡片</h3>"
    val HCARDITEM = "<li><a href=\"/card/"
    val HPACK = "<h3 class=\"no-underline\">热门卡包"
    val HPACKITEM = "<li><a href=\""

    var strSearch = ""
    var strCard = ""
    var strPackage = ""

    // hot search
    var htmlSearch = ahtml.substring(ahtml.indexOf(HSEARCH) + HSEARCH.length)
    htmlSearch = htmlSearch.substring(0, htmlSearch.indexOf(HULEND)).trim()
    while (true) {
        if (!htmlSearch.contains(HSEARCHITEM)) {
            break
        }
        htmlSearch = htmlSearch.substring(htmlSearch.indexOf(HSEARCHITEM) + HSEARCHITEM.length).trim()
        htmlSearch = htmlSearch.substring(htmlSearch.indexOf(">") + 1).trim()
        strSearch += "\"${htmlSearch.substring(0, htmlSearch.indexOf(HAEND)).trim()}\","
    }
    strSearch = strSearch.trim(',')
    // hot card
    var htmlCard = ahtml.substring(ahtml.indexOf(HCARD) + HCARD.length)
    htmlCard = htmlCard.substring(0, htmlCard.indexOf(HULEND)).trim()
    while (true) {
        if (!htmlCard.contains(HCARDITEM)) {
            break
        }
        htmlCard = htmlCard.substring(htmlCard.indexOf(HCARDITEM) + HCARDITEM.length).trim()
        strCard += "{\"hashid\":\"${htmlCard.substring(0, htmlCard.indexOf("\"")).trim()}\","
        htmlCard = htmlCard.substring(htmlCard.indexOf(">") + 1)
        strCard += "\"name\":\"${htmlCard.substring(0, htmlCard.indexOf(HAEND)).trim()}\"},"
    }
    strCard = strCard.trim(',')

    // hot package
    var htmlPack = ahtml.substring(ahtml.indexOf(HPACK) + HPACK.length)
    htmlPack = htmlPack.substring(0, htmlPack.indexOf(HULEND)).trim()
    while (true) {
        if (!htmlPack.contains(HPACKITEM)) {
            break
        }
        htmlPack = htmlPack.substring(htmlPack.indexOf(HPACKITEM) + HPACKITEM.length).trim()
        strPackage += "{\"packid\":\"${htmlPack.substring(0, htmlPack.indexOf("\"")).trim()}\","
        htmlPack = htmlPack.substring(htmlPack.indexOf(">") + 1).trim()
        strPackage += "\"name\":\"${htmlPack.substring(0, htmlPack.indexOf(HAEND)).trim()}\"},"
    }
    strPackage = strPackage.trim(',')
    val ret = "{\"result\":0, \"search\":[$strSearch], \"card\":[$strCard], \"pack\":[$strPackage]}"
    return ret
}