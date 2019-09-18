package com.rarnu.ygo.server

import com.rarnu.ktor.requestParameters
import com.rarnu.ktor.save
import com.rarnu.ygo.server.collect.CollectRequest2
import com.rarnu.ygo.server.common.deckPath
import com.rarnu.ygo.server.common.headPath
import com.rarnu.ygo.server.deck.DeckUtil
import io.ktor.application.application
import io.ktor.application.call
import io.ktor.request.receiveMultipart
import io.ktor.response.respondText
import io.ktor.routing.Routing
import io.ktor.routing.get
import io.ktor.routing.post
import io.ktor.util.pipeline.ContextDsl
import java.io.File
import java.util.*

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

    get("/mydecklist") {
        call.respondText {
            "{\"result\":0, \"data\":[${File(deckPath, localSession.userId.toString()).apply { 
                if (!exists()) mkdirs() 
            }.listFiles()?.joinToString(",") { 
                "{\"file\":\"${it.name}\",\"name\":\"${DeckUtil.getDeckName(it)}\"}" 
            } ?: ""}]}"
        }
    }

    post("/uploaddeck") {
        var ret = false
        val savefile = File(
            File(deckPath, localSession.userId.toString()).apply { if (!exists()) mkdirs() },
            UUID.randomUUID().toString()
        )
        val saved = call.receiveMultipart().save("file", savefile)
        if (saved) {
            if (!DeckUtil.isDeck(savefile)) {
                savefile.delete()
            } else {
                ret = true
            }
        }
        call.respondText { "{\"result\":${if (ret) 0 else 1}}" }
    }

    get("/mydeckdetail") {
        val uuid = call.requestParameters()["uuid"] ?: ""
        val loadfile = File(File(deckPath, localSession.userId.toString()).apply { if (!exists()) mkdirs() }, uuid)
        DeckUtil.loadMyDeck(loadfile) {
            call.respondText { it }
        }
    }
}