@file:Suppress("DuplicatedCode")

package com.rarnu.ygo.server

import com.rarnu.ktor.requestParameters
import com.rarnu.ygo.server.card.Request2
import io.ktor.application.application
import io.ktor.application.call
import io.ktor.response.respond
import io.ktor.response.respondText
import io.ktor.routing.Routing
import io.ktor.routing.get

fun Routing.serverRouting() {

    get("/hello") {
        call.respond("<html><head><script src='static/js/ktor.js'></script></head><body>Hello <button onclick='sayHello();'>say Hello</button></body></html>".toByteArray())
    }

    get("/search") {
        val p = call.requestParameters()
        val key = p["key"] ?: ""
        val page = (p["page"] ?: "1").toInt()
        if (key == "") {
            call.respondText { "{\"cards\":[],,\"meta\":{\"keyword\":\"\",\"count\":0,\"total_page\":0,\"cur_page\":1}}" }
        } else {
            Request2.search(key, page) { str ->
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
            Request2.cardDetailWiki(application, hash) { data, _, _ ->
                call.respondText { data }
            }
        }
    }

    get("/cardadjust") {
        val p = call.requestParameters()
        val hash = p["hash"] ?: ""
        if (hash == "") {
            call.respondText { "{\"result\":1}" }
        } else {
            Request2.cardDetailWiki(application, hash) { _, adjust, _ ->
                call.respondText { adjust }
            }
        }
    }

    get("/cardwiki") {
        val p = call.requestParameters()
        val hash = p["hash"] ?: ""
        if (hash == "") {
            call.respondText { "{\"result\":1}" }
        } else {
            Request2.cardDetailWiki(application, hash) { _, _, wiki ->
                call.respondText { wiki }
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
        Request2.hotest {
            call.respondText { it }
        }
    }
}