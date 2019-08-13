@file:Suppress("SqlDialectInspection", "SqlNoDataSourceInspection")

package com.rarnu.ygo.server.database

import com.rarnu.common.firstRecord
import com.rarnu.common.forEach
import com.rarnu.common.long
import com.rarnu.common.string
import com.rarnu.ktor.conn
import com.rarnu.ygo.server.card.*
import io.ktor.application.Application

class CardTable(private val app: Application) {
    fun loadCache() {
        val stmt = app.conn.prepareStatement("select hash, timeinfo, data, adjust, wiki from Card")
        val rs = stmt.executeQuery()
        rs.forEach {
            cacheMap[it.string("hash")] = CardCache2(it.string("data"), it.string("adjust"), it.string("wiki"), it.long("timeinfo"))
        }
        rs.close()
    }

    fun save(h: String, t: Long, d: String, a: String, w: String) {
        val stmt = app.conn.prepareStatement("insert into Card(hash, timeinfo, data, adjust, wiki) values (?, ?, ?, ?, ?)")
        stmt.setString(1, h)
        stmt.setLong(2, t)
        stmt.setString(3, d)
        stmt.setString(4, a)
        stmt.setString(5, w)
        try {
            stmt.executeUpdate()
        } catch (e: Throwable) {

        }
    }

    fun update(h: String, t: Long, d: String, a: String, w: String) {
        val stmt = app.conn.prepareStatement("update Card set data = ?, adjust = ?, wiki = ?, timeinfo = ? where hash = ?")
        stmt.setString(1, d)
        stmt.setString(2, a)
        stmt.setString(3, w)
        stmt.setLong(4, t)
        stmt.setString(5, h)
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

class CardPack(private val app: Application) {
    fun loadCache() {
        val stmt = app.conn.prepareStatement("select timeinfo, info from CardPack")
        val rs = stmt.executeQuery()
        rs.firstRecord {
            cachePack.timeinfo = it.long("timeinfo")
            cachePack.text = it.string("info")
        }
        rs.close()
    }

    fun save(t: Long, i: String) {
        val stmt = app.conn.prepareStatement("update CardPack set timeinfo = ?, info = ?")
        stmt.setLong(1, t)
        stmt.setString(2, i)
        if (stmt.executeUpdate() != 1) {
            val stmtIns = app.conn.prepareStatement("insert into CardPack(timeinfo, info) values(?, ?)")
            stmtIns.setLong(1, t)
            stmtIns.setString(2, i)
            stmtIns.executeUpdate()
        }
    }
}

class CardPackDetail(private val app: Application) {
    fun loadCache() {
        val stmt = app.conn.prepareStatement("select url, info, timeinfo from CardPackDetail")
        val rs = stmt.executeQuery()
        rs.forEach {
            cachePackDetail[it.string("url")] = CardDetail2(it.long("timeinfo"), it.string("info"))
        }
        rs.close()
    }

    fun save(u: String, t: Long, i: String) {
        val stmt = app.conn.prepareStatement("update CardPackDetail set info = ?, timeinfo = ? where url = ?")
        stmt.setString(1, i)
        stmt.setLong(2, t)
        stmt.setString(3, u)
        if (stmt.executeUpdate() != 1) {
            val stmtIns = app.conn.prepareStatement("insert into CardPackDetail(url, info, timeinfo) values(?, ?, ?)")
            stmtIns.setString(1, u)
            stmtIns.setString(2, i)
            stmtIns.setLong(3, t)
            stmtIns.executeUpdate()
        }
    }

}


val Application.cardTable: CardTable get() = CardTable(this)
val Application.limitTable: CardLimit get() = CardLimit(this)
val Application.packTable: CardPack get() = CardPack(this)
val Application.packDetailTable: CardPackDetail get() = CardPackDetail(this)
