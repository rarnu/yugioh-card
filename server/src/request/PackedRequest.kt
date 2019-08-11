package com.rarnu.ygo.server.request

import com.rarnu.common.http
import com.rarnu.common.runCommand
import com.rarnu.ygo.server.database.reqlog
import io.ktor.application.Application

fun differentDaysByMillisecond(date1: Long, date2: Long) = (date2 - date1) / (1000 * 3600 * 24)

fun req(u: String) = runCommand {
    commands.add("curl")
    commands.add(u)
}.output

/*
fun req(app: Application, u: String): String? {
    val startTime = System.currentTimeMillis()
    return http {
        url = u
        onSuccess { _, _, _ ->
            val endTime = System.currentTimeMillis()
            app.reqlog.log(u, 0, endTime - startTime, "")
        }
        onFail {
            val endTime = System.currentTimeMillis()
            app.reqlog.log(u, 1, endTime - startTime, "$it")
        }
    }
}
 */

fun deckReq(u: String, params: Map<String, String>? = null) = runCommand {
    commands.add("curl")
    params?.forEach { (t, u) ->
        commands.add("-F")
        commands.add("$t=$u")
    }
    commands.add(u)
}.output
