package com.rarnu.ygo.server

import com.rarnu.ktor.requestParameters
import com.rarnu.ygo.server.collect.CollectRequest2
import io.ktor.application.application
import io.ktor.application.call
import io.ktor.response.respondText
import io.ktor.routing.Routing
import io.ktor.routing.get
import io.ktor.util.pipeline.ContextDsl

@ContextDsl
fun Routing.collectRouting() {
    get("/iscardcollect") {
        val p = call.requestParameters()
        val hash = p["hash"] ?: ""
        CollectRequest2.isCardCollected(application, localSession.userId, hash) {
            call.respondText { it }
        }
    }

    get("/isdeckcollect") {
        val p = call.requestParameters()
        val data = p["data"] ?: ""
        CollectRequest2.isDeckCollected(application, localSession.userId, data) {
            call.respondText { it }
        }
    }

    get("/collectcard") {
        val p = call.requestParameters()
        val hash = p["hash"] ?: ""
        val name = p["name"] ?: ""
        CollectRequest2.collectCard(application, localSession.userId, hash, name) {
            call.respondText { it }
        }
    }

    get("/uncollectcard") {
        val p = call.requestParameters()
        val hash = p["hash"] ?: ""
        CollectRequest2.uncollectCard(application, localSession.userId, hash) {
            call.respondText { it }
        }
    }

    get("/collectdeck") {
        val p = call.requestParameters()
        val data = p["data"] ?: ""
        val name = p["name"] ?: ""
        CollectRequest2.collectDeck(application, localSession.userId, data, name) {
            call.respondText { it }
        }
    }

    get("/uncollectdeck") {
        val p = call.requestParameters()
        val data = p["data"] ?: ""
        CollectRequest2.uncollectDeck(application, localSession.userId, data) {
            call.respondText { it }
        }
    }

    get("/recentcollect") {
        CollectRequest2.getRecentCollect(application, localSession.userId) {
            call.respondText { it }
        }
    }

    get("/cardcollect") {
        CollectRequest2.getCardCollect(application, localSession.userId) {
            call.respondText { it }
        }
    }

    get("/deckcollect") {
        CollectRequest2.getDeckCollect(application, localSession.userId) {
            call.respondText { it }
        }
    }
}