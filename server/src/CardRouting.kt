@file:Suppress("DuplicatedCode")

package com.rarnu.ygo.server

import com.rarnu.ktor.requestParameters
import com.rarnu.ygo.server.card.Request2
import com.rarnu.ygo.server.database.reqlog
import io.ktor.application.application
import io.ktor.application.call
import io.ktor.response.respondText
import io.ktor.routing.Routing
import io.ktor.routing.get
import io.ktor.util.pipeline.ContextDsl

@ContextDsl
fun Routing.cardRouting() {

    get("/search") {
        val p = call.requestParameters()
        val key = p["key"] ?: ""
        val page = (p["page"] ?: "1").toInt()
        if (key == "") {
            call.respondText { "{\"cards\":[],\"meta\":{\"keyword\":\"\",\"count\":0,\"total_page\":0,\"cur_page\":1}}" }
        } else {
            Request2.search(application, key, page) { str ->
                call.respondText { str }
            }
        }
    }

    get("/carddetail") {
        val p = call.requestParameters()
        val hash = p["hash"] ?: ""
        if (hash == "") {
            call.respondText { "{\"result\":1}" }
        } else {
            Request2.cardDetailWiki(application, hash) { data, adjust, wiki ->
                call.respondText { "$data\\\\\\\\$adjust\\\\\\\\$wiki" }
            }
        }
    }

    get("/limit") {
        Request2.limit(application) {
            call.respondText { it }
        }
    }

    get("/packlist") {
        Request2.packlist(application) {
            call.respondText { it }
        }
    }

    get("/packdetail") {
        val p = call.requestParameters()
        val u = p["url"] ?: ""
        if (u == "") {
            call.respondText { "{\"result\":1}" }
        } else {
            Request2.packdetail(application, u) {
                call.respondText { it }
            }
        }
    }

    get("/hotest") {
        Request2.hotest(application) {
            call.respondText { it }
        }
    }
}