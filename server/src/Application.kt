package com.rarnu.ygo.server

import com.rarnu.ktor.installPlugin
import com.rarnu.ygo.server.database.*
import io.ktor.application.Application
import io.ktor.application.call
import io.ktor.http.content.default
import io.ktor.http.content.defaultResource
import io.ktor.http.content.resources
import io.ktor.http.content.static
import io.ktor.response.respondText
import io.ktor.routing.get
import io.ktor.routing.route
import io.ktor.routing.routing

fun main(args: Array<String>): Unit = io.ktor.server.tomcat.EngineMain.main(args)

@Suppress("unused")
fun Application.module() {
    installPlugin<ServerSession>(sessionIdentifier = "ServerSession", headers = mapOf("X-Engine" to "Ktor")) { }

    // load cache
    cardTable.loadCache()
    limitTable.loadCache()
    packTable.loadCache()
    packDetailTable.loadCache()

    deckTheme.loadCache()
    deckCategory.loadCache()
    deckInCategory.loadCache()
    deckTable.loadCache()

    routing {
        resources("web")
        resources("static")
        static("/static") { resources("static") }
        static { defaultResource("index.html", "web") }
        cardRouting()
        deckRouting()
    }

}