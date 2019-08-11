package com.rarnu.ygo.server.card

import com.rarnu.ygo.server.database.cardTable
import com.rarnu.ygo.server.database.limitTable
import com.rarnu.ygo.server.database.packDetailTable
import com.rarnu.ygo.server.database.packTable
import com.rarnu.ygo.server.request.differentDaysByMillisecond
import com.rarnu.ygo.server.request.req
import io.ktor.application.Application
import kotlin.collections.set

private const val BASE_URL = "https://www.ourocg.cn"
// private const val RES_URL = "http://ocg.resource.m2v.cn/%d.jpg"

object Request2 {
    suspend fun search(key: String, page: Int, callback: suspend (String) -> Unit) =
        callback(req("$BASE_URL/search/$key/$page").parse0())

    suspend fun cardDetailWiki(app: Application, hashid: String, callback: suspend (String, String, String) -> Unit) {

        suspend fun innerRequest(hashid: String, callback: suspend (String, String, String) -> Unit) {
            val detail = req("$BASE_URL/card/$hashid")
            val wiki = req("$BASE_URL/card/$hashid/wiki")
            val d = detail.parse1()
            val a = detail.parse2()
            val w = wiki.parse3()
            callback(d, a, w)
        }

        val c = cacheMap[hashid]
        if (c == null) {
            innerRequest(hashid) { d, a, w ->
                cacheMap[hashid] = CardCache2(d, a, w)
                app.cardTable.save(hashid, d, a, w)
                callback(d, a, w)
            }
        } else {
            if (c.data == "" || c.adjust == "" || c.wiki == "") {
                innerRequest(hashid) { d, a, w ->
                    cacheMap[hashid] = CardCache2(d, a, w)
                    app.cardTable.update(hashid, d, a, w)
                    callback(d, a, w)
                }
            } else {
                callback(c.data, c.adjust, c.wiki)
            }
        }
    }

    suspend fun limit(app: Application, callback: suspend (String) -> Unit) {
        val txt = cacheLimit.text
        val time = cacheLimit.timeinfo
        val current = System.currentTimeMillis()
        if (txt == "" || differentDaysByMillisecond(current, time) > 1) {
            val limit = req("$BASE_URL/Limit-Latest").parse4()
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
        if (txt == "" || differentDaysByMillisecond(current, time) > 1) {
            val pack = req("$BASE_URL/package").parse5()
            cachePack.timeinfo = current
            cachePack.text = pack
            app.packTable.save(current, pack)
            callback(pack)
        } else {
            callback(txt)
        }
    }

    suspend fun packdetail(app: Application, url: String, callback: suspend (String) -> Unit) {
        val txt = cachePackDetail[url]
        if (txt == null || txt == "") {
            val detail = req("$BASE_URL$url").parse0()
            cachePackDetail[url] = detail
            app.packDetailTable.save(url, detail)
            callback(detail)
        } else {
            callback(txt)
        }
    }

    suspend fun hotest(callback: suspend (String) -> Unit) = callback(req(BASE_URL).parse6())

}