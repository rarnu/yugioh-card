package com.rarnu.ygo.server

import io.ktor.application.call
import io.ktor.response.respondRedirect
import io.ktor.routing.Routing
import io.ktor.routing.get

fun Routing.jumpRouting() {
    get("/nexus") {
        //  jump to my nexus
        call.respondRedirect("http://119.3.22.119:8081")
    }
}