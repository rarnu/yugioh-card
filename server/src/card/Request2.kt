package com.rarnu.ygo.server.card

import com.rarnu.ygo.server.database.cardTable
import com.rarnu.ygo.server.database.limitTable
import com.rarnu.ygo.server.database.packDetailTable
import com.rarnu.ygo.server.database.packTable
import com.rarnu.ygo.server.request.differentDaysByMillisecond
import com.rarnu.ygo.server.request.oGetRequest
import io.ktor.application.Application
import kotlin.collections.set

private const val BASE_URL = "https://www.ourocg.cn"
// private const val RES_URL = "http://ocg.resource.m2v.cn/%d.jpg"

object Request2 {
    suspend fun search(key: String, page: Int, callback: suspend (String) -> Unit) =
        callback(oGetRequest("$BASE_URL/search/$key/$page").parse0())

    suspend fun cardDetailWiki(app: Application, hashid: String, callback: suspend (String, String, String) -> Unit) {

        suspend fun innerRequest(hashid: String, callback: suspend (String, String, String) -> Unit) {
            val detail = oGetRequest("$BASE_URL/card/$hashid")
            val wiki = oGetRequest("$BASE_URL/card/$hashid/wiki")
            val d = detail.parse1()
            val a = detail.parse2()
            val w = wiki.parse3()
            callback(d, a, w)
        }

        val c = cacheMap[hashid]
        val curr = System.currentTimeMillis()
        if (c == null || differentDaysByMillisecond(curr, c.timeinfo) > 30) {
            innerRequest(hashid) { d, a, w ->
                cacheMap[hashid] = CardCache2(d, a, w, curr)
                app.cardTable.save(hashid, curr, d, a, w)
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
        if (txt == "" || differentDaysByMillisecond(current, time) > 30) {
            val limit = oGetRequest("$BASE_URL/Limit-Latest").parse4()
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
        if (txt == "" || differentDaysByMillisecond(current, time) > 30) {
            val pack = oGetRequest("$BASE_URL/package").parse5()
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
        if (detail == null || differentDaysByMillisecond(current, detail.timeinfo) > 30) {
            val txt = oGetRequest("$BASE_URL$url").parse0()
            cachePackDetail[url] = CardDetail2(current, txt)
            app.packDetailTable.save(url, current, txt)
            callback(txt)
        } else {
            callback(detail.text)
        }
    }

    suspend fun hotest(callback: suspend (String) -> Unit) = callback(oGetRequest(BASE_URL).parse6())

}