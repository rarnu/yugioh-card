package com.rarnu.ygo.server.request

import com.rarnu.common.runCommand
import com.rarnu.ktor.config
import com.rarnu.ygo.server.database.reqlog
import io.ktor.application.Application

private var monoCmd = ""
private var wrapperCmd = ""
private var curlCmd = ""

fun Application.loadNetworkCommand() {
    monoCmd = config("ktor.network.mono")
    wrapperCmd = config("ktor.network.wrapper")
    curlCmd = config("ktor.network.curl")
    println("load curl => $curlCmd")
    println("load mono => $monoCmd")
    println("load wrapper => $wrapperCmd")
}

fun differentDaysByMillisecond(date1: Long, date2: Long) = (date2 - date1) / (1000 * 3600 * 24)

fun oGetRequest(app: Application, u: String) = runCommand {
    println("O.Request.GET => $u")
    commands.add(curlCmd)
    commands.add("--max-time")
    commands.add("30")
    commands.add(u)
    result { _, error ->
        if (error != "" && !error.contains("% Total")) {
            app.reqlog.log("cmd.o.get: $u", 1, 0, error)
        }
    }
}.output

fun dGetRequest(app: Application, u: String) = runCommand {
    println("D.Request.GET => $u")
    commands.add(monoCmd)
    commands.add(wrapperCmd)
    commands.add("GET")
    commands.add(u)
    result { _, error ->
        if (error != "") {
            app.reqlog.log("cmd.d.get: $u", 1, 0, error)
        }
    }
}.output

fun dPostRequest(app: Application, u: String, params: Map<String, String>? = null) = runCommand {
    println("D.Request.POST => $u")
    commands.add(monoCmd)
    commands.add(wrapperCmd)
    commands.add("POST")
    commands.add(u)
    commands.add(params?.map { "${it.key}=${it.value}" }?.joinToString("&") ?: "")
    result { _, error ->
        if (error != "") {
            app.reqlog.log("cmd.d.post: $u", 1, 0, error)
        }
    }
}.output
