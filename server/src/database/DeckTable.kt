@file:Suppress("SqlDialectInspection")

package com.rarnu.ygo.server.database

import com.rarnu.common.firstRecord
import com.rarnu.common.forEach
import com.rarnu.common.long
import com.rarnu.common.string
import com.rarnu.ktor.conn
import com.rarnu.ygo.server.deck.*
import io.ktor.application.Application

class DeckTheme(private val app: Application) {
    fun loadCache() =
        app.conn.prepareStatement("select timeinfo, info from DeckTheme").use { s ->
            s.executeQuery().use { r ->
                r.firstRecord {
                    cacheDeckTheme.timeinfo = it.long("timeinfo")
                    cacheDeckTheme.text = it.string("info")
                }
            }
        }

    fun save(t: Long, i: String) =
        app.conn.prepareStatement("update DeckTheme set timeinfo = ?, info = ?").use { s ->
            s.setLong(1, t)
            s.setString(2, i)
            if (s.executeUpdate() != 1) {
                app.conn.prepareStatement("insert into DeckTheme(timeinfo, info) values(?, ?)").use { s2 ->
                    s2.setLong(1, t)
                    s2.setString(2, i)
                    s2.executeUpdate()
                }
            }
        }
}

class DeckCategory(private val app: Application) {
    fun loadCache() =
        app.conn.prepareStatement("select timeinfo, info from DeckCategory").use { s ->
            s.executeQuery().use { r ->
                r.firstRecord {
                    cacheDeckCategory.timeinfo = it.long("timeinfo")
                    cacheDeckCategory.text = it.string("info")
                }
            }
        }

    fun save(t: Long, i: String) =
        app.conn.prepareStatement("update DeckCategory set timeinfo = ?, info = ?").use { s ->
            s.setLong(1, t)
            s.setString(2, i)
            if (s.executeUpdate() != 1) {
                app.conn.prepareStatement("insert into DeckCategory(timeinfo, info) values(?, ?)").use { s2 ->
                    s2.setLong(1, t)
                    s2.setString(2, i)
                    s2.executeUpdate()
                }
            }
        }
}

class DeckInCategory(private val app: Application) {
    fun loadCache() =
        app.conn.prepareStatement("select hash, timeinfo, info from DeckInCategory").use { s ->
            s.executeQuery().use { r ->
                r.forEach {
                    cacheDeckInCategory[it.string("hash")] = DeckInCategory2(it.long("timeinfo"), it.string("info"))
                }
            }
        }

    fun save(h: String, t: Long, i: String) =
        app.conn.prepareStatement("update DeckInCategory set timeinfo = ?, info = ? where hash = ?").use { s ->
            s.setLong(1, t)
            s.setString(2, i)
            s.setString(3, h)
            if (s.executeUpdate() != 1) {
                app.conn.prepareStatement("insert into DeckInCategory(hash, timeinfo, info) values(?, ?, ?)")
                    .use { s2 ->
                        s2.setString(1, h)
                        s2.setLong(2, t)
                        s2.setString(3, i)
                        s2.executeUpdate()
                    }
            }
        }

}

class DeckTable(private val app: Application) {
    fun loadCache() =
        app.conn.prepareStatement("select code, timeinfo, info from Deck").use { s ->
            s.executeQuery().use { r ->
                r.forEach {
                    cacheDeck[it.string("code")] = Deck2(it.long("timeinfo"), it.string("info"))
                }
            }
        }

    fun save(c: String, t: Long, i: String) =
        app.conn.prepareStatement("update Deck set timeinfo = ?, info = ? where code = ?").use { s ->
            s.setLong(1, t)
            s.setString(2, i)
            s.setString(3, c)
            if (s.executeUpdate() != 1) {
                app.conn.prepareStatement("insert into Deck(code, timeinfo, info) values(?, ?, ?)").use { s2 ->
                    s2.setString(1, c)
                    s2.setLong(2, t)
                    s2.setString(3, i)
                    s2.executeUpdate()
                }
            }
        }
}

val Application.deckTheme: DeckTheme get() = DeckTheme(this)
val Application.deckCategory: DeckCategory get() = DeckCategory(this)
val Application.deckInCategory: DeckInCategory get() = DeckInCategory(this)
val Application.deckTable: DeckTable get() = DeckTable(this)