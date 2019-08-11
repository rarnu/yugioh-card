package com.rarnu.ygo.server

import com.rarnu.ktor.requestParameters
import com.rarnu.ygo.server.deck.DeckRequest2
import io.ktor.application.call
import io.ktor.application.application
import io.ktor.response.respondText
import io.ktor.routing.Routing
import io.ktor.routing.get

fun Routing.deckRouting() {
    get("/decktheme") {
        DeckRequest2.theme(application) {
            call.respondText { it }
        }
    }

    get("/deckcategory") {
        DeckRequest2.category(application) {
            call.respondText { it }
        }
    }

    get("/deckincategory") {
        val hash = call.requestParameters()["hash"] ?: ""
        if (hash != "") {
            DeckRequest2.inCategory(application, hash) {
                call.respondText { it }
            }
        } else {
            call.respondText { "{\"result\":1}" }
        }
    }

    get("/deck") {
        val code = call.requestParameters()["code"] ?: ""
        if (code != "") {
            DeckRequest2.deck(application, code) {
                call.respondText { it }
            }
        } else {
            call.respondText { "{\"result\":1}" }
        }
    }
}