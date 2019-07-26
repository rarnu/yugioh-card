package com.rarnu.ygo.server.card

import com.rarnu.common.http
import com.rarnu.ygo.server.database.*
import io.ktor.application.Application

const val BASE_URL = "https://www.ourocg.cn"
const val RES_URL = "http://ocg.resource.m2v.cn/%d.jpg"

object Request2 {
    suspend fun search(app: Application, key: String, page: Int, callback: suspend (String) -> Unit) =
        callback((req(app, "$BASE_URL/search/$key/$page") ?: "").parse0())

    private fun differentDaysByMillisecond(date1: Long, date2: Long) = (date2 - date1) / (1000 * 3600 * 24)

    suspend fun cardDetailWiki(app: Application, hashid: String, callback: suspend (String, String, String) -> Unit) {

        suspend fun innerRequest(hashid: String, callback: suspend (String, String, String) -> Unit) {
            val detail = req(app, "$BASE_URL/card/$hashid") ?: ""
            val wiki = req(app, "$BASE_URL/card/$hashid/wiki") ?: ""
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
            val limit = (req(app, "$BASE_URL/Limit-Latest") ?: "").parse4()
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
            val pack = (req(app, "$BASE_URL/package") ?: "").parse5()
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
            val detail = (req(app, "$BASE_URL$url") ?: "").parse0()
            cachePackDetail[url] = detail
            app.packDetailTable.save(url, detail)
            callback(detail)
        } else {
            callback(txt)
        }
    }

    suspend fun hotest(app: Application, callback: suspend (String) -> Unit) = callback((req(app, BASE_URL) ?: "").parse6())

    private suspend fun req(app: Application, u: String): String? {
        val startTime = System.currentTimeMillis()
        return http {
            url = u
            onSuccess { _, _, _ ->
                val endTime = System.currentTimeMillis()
                app.reqlog.log(u, 0, endTime - startTime, "")
            }
            onFail {
                val endTime = System.currentTimeMillis()
                app.reqlog.log(u, 1, endTime - startTime, "$it")
            }
        }
    }

}