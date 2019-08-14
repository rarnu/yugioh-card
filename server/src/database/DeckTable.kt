package com.rarnu.ygo.server.database

import com.rarnu.common.firstRecord
import com.rarnu.common.forEach
import com.rarnu.common.long
import com.rarnu.common.string
import com.rarnu.ktor.conn
import com.rarnu.ygo.server.deck.*
import io.ktor.application.Application

class DeckTheme(private val app: Application) {
    fun loadCache() {
        val stmt = app.conn.prepareStatement("select timeinfo, info from DeckTheme")
        val rs = stmt.executeQuery()
        rs.firstRecord {
            cacheDeckTheme.timeinfo = it.long("timeinfo")
            cacheDeckTheme.text = it.string("info")
        }
        rs.close()
    }

    fun save(t: Long, i: String) {
        val stmt = app.conn.prepareStatement("update DeckTheme set timeinfo = ?, info = ?")
        stmt.setLong(1, t)
        stmt.setString(2, i)
        if (stmt.executeUpdate() != 1) {
            val stmtIns = app.conn.prepareStatement("insert into DeckTheme(timeinfo, info) values(?, ?)")
            stmtIns.setLong(1, t)
            stmtIns.setString(2, i)
            stmtIns.executeUpdate()
        }
    }
}

class DeckCategory(private val app: Application) {
    fun loadCache() {
        val stmt = app.conn.prepareStatement("select timeinfo, info from DeckCategory")
        val rs = stmt.executeQuery()
        rs.firstRecord {
            cacheDeckCategory.timeinfo = it.long("timeinfo")
            cacheDeckCategory.text = it.string("info")
        }
        rs.close()
    }

    fun save(t: Long, i: String) {
        val stmt = app.conn.prepareStatement("update DeckCategory set timeinfo = ?, info = ?")
        stmt.setLong(1, t)
        stmt.setString(2, i)
        if (stmt.executeUpdate() != 1) {
            val stmtIns = app.conn.prepareStatement("insert into DeckCategory(timeinfo, info) values(?, ?)")
            stmtIns.setLong(1, t)
            stmtIns.setString(2, i)
            stmtIns.executeUpdate()
        }
    }
}

class DeckInCategory(private val app: Application) {
    fun loadCache() {
        val stmt = app.conn.prepareStatement("select hash, timeinfo, info from DeckInCategory")
        val rs = stmt.executeQuery()
        rs.forEach {
            cacheDeckInCategory[it.string("hash")] = DeckInCategory2(it.long("timeinfo"), it.string("info"))
        }
        rs.close()
    }

    fun save(h: String, t: Long, i: String) {
        val stmt = app.conn.prepareStatement("update DeckInCategory set timeinfo = ?, info = ? where hash = ?")
        stmt.setLong(1, t)
        stmt.setString(2, i)
        stmt.setString(3, h)
        if (stmt.executeUpdate() != 1) {
            val stmtIns = app.conn.prepareStatement("insert into DeckInCategory(hash, timeinfo, info) values(?, ?, ?)")
            stmtIns.setString(1, h)
            stmtIns.setLong(2, t)
            stmtIns.setString(3, i)
            stmtIns.executeUpdate()
        }
    }

}

class DeckTable(private val app: Application) {
    fun loadCache() {
        val stmt = app.conn.prepareStatement("select code, timeinfo, info from Deck")
        val rs = stmt.executeQuery()
        rs.forEach {
            cacheDeck[it.string("code")] = Deck2(it.long("timeinfo"), it.string("info"))
        }
        rs.close()
    }

    fun save(c: String, t: Long, i: String) {
        val stmt = app.conn.prepareStatement("update Deck set timeinfo = ?, info = ? where code = ?")
        stmt.setLong(1, t)
        stmt.setString(2, i)
        stmt.setString(3, c)
        if (stmt.executeUpdate() != 1) {
            val stmtIns = app.conn.prepareStatement("insert into Deck(code, timeinfo, info) values(?, ?, ?)")
            stmtIns.setString(1, c)
            stmtIns.setLong(2, t)
            stmtIns.setString(3, i)
            stmtIns.executeUpdate()
        }
    }
}

val Application.deckTheme: DeckTheme get() = DeckTheme(this)
val Application.deckCategory: DeckCategory get() = DeckCategory(this)
val Application.deckInCategory: DeckInCategory get() = DeckInCategory(this)
val Application.deckTable: DeckTable get() = DeckTable(this)