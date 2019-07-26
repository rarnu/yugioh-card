package com.rarnu.ygo.server

import com.rarnu.ktor.installPlugin
import com.rarnu.ygo.server.database.cardTable
import com.rarnu.ygo.server.database.limitTable
import com.rarnu.ygo.server.database.packDetailTable
import com.rarnu.ygo.server.database.packTable
import io.ktor.application.Application
import io.ktor.http.content.defaultResource
import io.ktor.http.content.resources
import io.ktor.http.content.static
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

    routing {
        resources("web")
        resources("static")
        static("/static") { resources("static") }
        static { defaultResource("index.html", "web") }
        serverRouting()
        sqlRouting()
    }
}