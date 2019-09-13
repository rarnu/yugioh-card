@file:Suppress("SqlDialectInspection")

package com.rarnu.ygo.server.database

import com.rarnu.ktor.conn
import io.ktor.application.Application

class ReqLog(private val app: Application) {
    fun log(req: String, ret: Int, waste: Long, reason: String) =
        app.conn.prepareStatement("insert into Log(timeinfo, req, result, waste, reason) values(?, ?, ?, ?, ?)").use { s ->
            s.setLong(1, System.currentTimeMillis())
            s.setString(2, req)
            s.setInt(3, ret)
            s.setLong(4, waste)
            s.setString(5, reason)
            s.executeUpdate()
        }
}

val Application.reqlog: ReqLog get() = ReqLog(this)