package com.rarnu.ygo.server

import com.rarnu.ktor.requestParameters
import com.rarnu.ktor.resolveFile
import com.rarnu.ktor.resolveFileSave
import com.rarnu.ygo.server.deck.DeckRequest2
import com.rarnu.ygo.server.request.doDownloadImage
import com.rarnu.ygo.server.request.imgPath
import io.ktor.application.call
import io.ktor.application.application
import io.ktor.response.respond
import io.ktor.response.respondFile
import io.ktor.response.respondText
import io.ktor.routing.Routing
import io.ktor.routing.get
import io.ktor.util.pipeline.ContextDsl
import java.io.File

@ContextDsl
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

    get("/deckimage") {
        val name = call.requestParameters()["name"] ?: ""
        if (name != "") {
            val localFile = File(imgPath, name.substringAfterLast("/"))
            if (localFile.exists()) {
                call.respondFile(localFile)
            } else {
                doDownloadImage(application, "https://www.ygo-sem.cn/$name", localFile.absolutePath)
                if (localFile.exists()) {
                    call.respondFile(localFile)
                } else {
                    call.respondFile(call.resolveFile("static/image/notfound.jpg")!!)
                }
            }
        } else {
            call.respondText { "{\"result\":1}" }
        }
    }
}