fun String.parse0() = getStoredJson(this)
fun String.parse1() = getArticle(this)
fun String.parse2() = getAdjust(this)
fun String.parse3() = getWiki(this)

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
        ceffect = tmp.substring(0, tmp.indexOf("<span v-if=\"text_version == ''\"")).trim().replace("\n", "").replace("\r", "")
        ceffect = parseTextVersion(ceffect)
        tmp = tmp.substring(tmp.indexOf(H6) + H6.length)
        if (tmp.indexOf(HTABLE) != -1) {
            tmp = tmp.substring(0, tmp.indexOf(HTABLE)).trim()
            cpacklist = getPackList(tmp)
        }
    }
    val ret = "{\"result\":0, \"data\":{\"name\":\"$cname\",\"japname\":\"$cjapname\",\"enname\":\"$cenname\",\"cardtype\":\"$ccardtype\",\"password\":\"$cpassword\",\"limit\":\"$climit\",\"belongs\":\"$cbelongs\",\"rare\":\"$crare\",\"pack\":\"$cpack\",\"effect\":\"$ceffect\",\"race\":\"$crace\",\"element\":\"$celement\",\"level\":\"$clevel\",\"atk\":\"$catk\",\"def\":\"$cdef\",\"link\":\"$clink\",\"linkarrow\":\"$clinkarrow\",\"imageid\":\"$cimgid\",\"packs\":[$cpacklist]}}"
    return ret
}

private fun parseTextVersion(astr: String): String {
    val TEMPTAG = "<template v-if=\"text_version == 'nw'\">"
    val TEMPCLOSETAG = "</template>"
    var ret = astr
    if (ret.contains("<template")) {
        ret = ret.substring(ret.indexOf(TEMPTAG) + TEMPTAG.length).trim()

        if (ret.contains(TEMPCLOSETAG)) {
            ret = ret.substring(0, ret.indexOf(TEMPCLOSETAG)).trim()
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
    if (ahtml == "") {
        return "NULL"
    }
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