@file:Suppress("SqlDialectInspection", "SqlNoDataSourceInspection")

package com.rarnu.ygo.server.database

import com.rarnu.common.firstRecord
import com.rarnu.common.forEach
import com.rarnu.common.long
import com.rarnu.common.string
import com.rarnu.ktor.conn
import com.rarnu.ygo.server.card.CardCache2
import com.rarnu.ygo.server.card.cacheLimit
import com.rarnu.ygo.server.card.cacheMap
import io.ktor.application.Application

class CardTable(private val app: Application) {
    fun loadCache() {
        val stmt = app.conn.prepareStatement("select hash, data, adjust, wiki from Card")
        val rs = stmt.executeQuery()
        rs.forEach {
            cacheMap[it.string("hash")] = CardCache2(it.string("data"), it.string("adjust"), it.string("wiki"))
        }
        rs.close()
    }

    fun save(h: String, d: String, a: String, w: String) {
        val stmt = app.conn.prepareStatement("insert into Card(hash, data, adjust, wiki) values (?, ?, ?, ?)")
        stmt.setString(1, h)
        stmt.setString(2, d)
        stmt.setString(3, a)
        stmt.setString(4, w)
        try {
            stmt.executeUpdate()
        } catch (e: Throwable) {

        }
    }

    fun update(h: String, d: String, a: String, w: String) {
        val stmt = app.conn.prepareStatement("update Card set data = ?, adjust = ?, wiki = ? where hash = ?")
        stmt.setString(1, d)
        stmt.setString(2, a)
        stmt.setString(3, w)
        stmt.setString(4, h)
        stmt.executeUpdate()
    }
}


class CardLimit(private val app: Application) {
    fun loadCache() {
        val stmt = app.conn.prepareStatement("select timeinfo, info from CardLimit")
        val rs = stmt.executeQuery()
        rs.firstRecord {
            cacheLimit.timeinfo = it.long("timeinfo")
            cacheLimit.text = it.string("info")
        }
        rs.close()
    }

    fun save(t: Long, i: String) {
        val stmt = app.conn.prepareStatement("update CardLimit set timeinfo = ?, info = ?")
        stmt.setLong(1, t)
        stmt.setString(2, i)
        if (stmt.executeUpdate() != 1) {
            val stmtIns = app.conn.prepareStatement("insert into CardLimit(timeinfo, info) values(?, ?)")
            stmtIns.setLong(1, t)
            stmtIns.setString(2, i)
            stmtIns.executeUpdate()
        }
    }
}

val Application.cardTable: CardTable get() = CardTable(this)
val Application.limitTable: CardLimit get() = CardLimit(this)