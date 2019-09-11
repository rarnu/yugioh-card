@file:Suppress("SqlDialectInspection")

package com.rarnu.ygo.server.database

import com.rarnu.ktor.conn
import io.ktor.application.Application

class ReqLog(private val app: Application) {
    fun log(req: String, ret: Int, waste: Long, reason: String) {
        app.conn.prepareStatement("insert into Log(timeinfo, req, result, waste, reason) values(?, ?, ?, ?, ?)").apply {
            setLong(1, System.currentTimeMillis())
            setString(2, req)
            setInt(3, ret)
            setLong(4, waste)
            setString(5, reason)
            executeUpdate()
            close()
        }
    }
}

val Application.reqlog: ReqLog get() = ReqLog(this)