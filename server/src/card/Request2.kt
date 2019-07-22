package com.rarnu.ygo.server.card

import com.rarnu.common.httpGet
import com.rarnu.ygo.server.database.cardTable
import com.rarnu.ygo.server.database.limitTable
import io.ktor.application.Application

const val BASE_URL = "https://www.ourocg.cn"
const val RES_URL = "http://ocg.resource.m2v.cn/%d.jpg"

object Request2 {
    suspend fun search(key: String, page: Int, callback: suspend (String) -> Unit) = callback((httpGet("$BASE_URL/search/$key/$page") ?: "").parse0())

    private suspend fun innerRequest(hashid: String, callback: suspend (String, String, String) -> Unit) {
        val detail = httpGet("$BASE_URL/card/$hashid") ?: ""
        val wiki = httpGet("$BASE_URL/card/$hashid/wiki") ?: ""
        val d = detail.parse1()
        val a = detail.parse2()
        val w = wiki.parse3()
        callback(d, a, w)
    }

    private fun differentDaysByMillisecond(date1: Long, date2: Long): Long {
        return (date2 - date1) / (1000 * 3600 * 24)
    }

    suspend fun cardDetailWiki(app: Application, hashid: String, callback: suspend (String, String, String) -> Unit) {
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
            val limit = (httpGet("$BASE_URL/Limit-Latest") ?: "").parse4()
            cacheLimit.timeinfo = current
            cacheLimit.text = limit
            app.limitTable.save(current, limit)
            callback(limit)
        } else {
            callback(txt)
        }
    }
}