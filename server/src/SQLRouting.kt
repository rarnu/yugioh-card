package com.rarnu.ygo.server

import com.rarnu.ktor.requestParameters
import com.rarnu.ygo.server.database.sqlLog
import io.ktor.application.application
import io.ktor.application.call
import io.ktor.response.respondText
import io.ktor.routing.Routing
import io.ktor.routing.post

fun Routing.sqlRouting() {
    post("/sql") {
        val p = call.requestParameters()
        val sql = p["sql"] ?: ""
        println(sql)
        if (sql == "") {
            call.respondText { "" }
        } else {
            call.respondText { application.sqlLog.search(sql.replace("+", " ")) }
        }
    }
}