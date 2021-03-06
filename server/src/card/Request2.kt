package com.rarnu.ygo.server.card

import com.rarnu.ygo.server.common.REFRESH_DAYS
import com.rarnu.ygo.server.database.cardTable
import com.rarnu.ygo.server.database.limitTable
import com.rarnu.ygo.server.database.packDetailTable
import com.rarnu.ygo.server.database.packTable
import com.rarnu.ygo.server.common.differentDaysByMillisecond
import com.rarnu.ygo.server.common.oGetRequest
import io.ktor.application.Application
import kotlin.collections.set

private const val BASE_URL = "https://www.ourocg.cn"

object Request2 {
    suspend fun search(app: Application, key: String, page: Int, callback: suspend (String) -> Unit) =
        callback(oGetRequest(app, "$BASE_URL/search/$key/$page").parse0())

    suspend fun cardHashByImgId(imgid: String, callback: suspend (String, String) -> Unit) {
        val c = cacheMap.filterValues { it.imgid == imgid }
        if (c.isNotEmpty()) {
            callback(c.keys.elementAt(0), c.values.elementAt(0).nwname)
        } else {
            callback("", "")
        }
    }

    suspend fun cardDetailWiki(app: Application, hashid: String, callback: suspend (String, String, String) -> Unit) {

        suspend fun innerRequest(hashid: String, callback: suspend (String, String, String, String, String) -> Unit) {
            val detail = oGetRequest(app, "$BASE_URL/card/$hashid")
            val wiki = oGetRequest(app, "$BASE_URL/card/$hashid/wiki")
            var nwname = ""
            var imgid = ""
            val d = detail.parse1 { p1, p2 ->
                nwname = p1
                imgid = p2
            }
            val a = detail.parse2()
            val w = wiki.parse3()
            callback(d, a, w, nwname, imgid)
        }

        val c = cacheMap[hashid]
        val curr = System.currentTimeMillis()
        if (c == null || differentDaysByMillisecond(curr, c.timeinfo) > REFRESH_DAYS) {
            innerRequest(hashid) { d, a, w, nwn, imgid ->
                cacheMap[hashid] = CardCache2(d, a, w, curr, nwn, imgid)
                app.cardTable.save(hashid, curr, d, a, w, nwn, imgid)
                callback(d, a, w)
            }
        } else {
            callback(c.data, c.adjust, c.wiki)
        }
    }

    suspend fun limit(app: Application, callback: suspend (String) -> Unit) {
        val txt = cacheLimit.text
        val time = cacheLimit.timeinfo
        val current = System.currentTimeMillis()
        if (txt == "" || differentDaysByMillisecond(current, time) > REFRESH_DAYS) {
            val limit = oGetRequest(app, "$BASE_URL/Limit-Latest").parse4()
            cacheLimit.timeinfo = current
            cacheLimit.text = limit
            app.limitTable.save(current, limit)
            callback(limit)
        } else {
            callback(txt)
        }
    }

    suspend fun packlist(app: Application, callback: suspend (String) -> Unit) {
        val txt = cachePack.text
        val time = cachePack.timeinfo
        val current = System.currentTimeMillis()
        if (txt == "" || differentDaysByMillisecond(current, time) > REFRESH_DAYS) {
            val pack = oGetRequest(app, "$BASE_URL/package").parse5()
            cachePack.timeinfo = current
            cachePack.text = pack
            app.packTable.save(current, pack)
            callback(pack)
        } else {
            callback(txt)
        }
    }

    suspend fun packdetail(app: Application, url: String, callback: suspend (String) -> Unit) {
        val detail = cachePackDetail[url]
        val current = System.currentTimeMillis()
        if (detail == null || differentDaysByMillisecond(current, detail.timeinfo) > REFRESH_DAYS) {
            val txt = oGetRequest(app, "$BASE_URL$url").parse0()
            cachePackDetail[url] = CardDetail2(current, txt)
            app.packDetailTable.save(url, current, txt)
            callback(txt)
        } else {
            callback(detail.text)
        }
    }

    suspend fun hotest(app: Application, callback: suspend (String) -> Unit) = callback(oGetRequest(app, BASE_URL).parse6())

}