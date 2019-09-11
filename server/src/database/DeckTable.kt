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
    fun loadCache() {
        app.conn.prepareStatement("select timeinfo, info from DeckTheme").apply {
            executeQuery().apply {
                firstRecord {
                    cacheDeckTheme.timeinfo = it.long("timeinfo")
                    cacheDeckTheme.text = it.string("info")
                }
                close()
            }
            close()
        }
    }

    fun save(t: Long, i: String) {
        app.conn.prepareStatement("update DeckTheme set timeinfo = ?, info = ?").apply {
            setLong(1, t)
            setString(2, i)
            if (executeUpdate() != 1) {
                app.conn.prepareStatement("insert into DeckTheme(timeinfo, info) values(?, ?)").apply {
                    setLong(1, t)
                    setString(2, i)
                    executeUpdate()
                    close()
                }
            }
            close()
        }
    }
}

class DeckCategory(private val app: Application) {
    fun loadCache() {
        app.conn.prepareStatement("select timeinfo, info from DeckCategory").apply {
            executeQuery().apply {
                firstRecord {
                    cacheDeckCategory.timeinfo = it.long("timeinfo")
                    cacheDeckCategory.text = it.string("info")
                }
                close()
            }
            close()
        }
    }

    fun save(t: Long, i: String) {
        app.conn.prepareStatement("update DeckCategory set timeinfo = ?, info = ?").apply {
            setLong(1, t)
            setString(2, i)
            if (executeUpdate() != 1) {
                app.conn.prepareStatement("insert into DeckCategory(timeinfo, info) values(?, ?)").apply {
                    setLong(1, t)
                    setString(2, i)
                    executeUpdate()
                    close()
                }
            }
            close()
        }
    }
}

class DeckInCategory(private val app: Application) {
    fun loadCache() {
        app.conn.prepareStatement("select hash, timeinfo, info from DeckInCategory").apply {
            executeQuery().apply {
                forEach {
                    cacheDeckInCategory[it.string("hash")] = DeckInCategory2(it.long("timeinfo"), it.string("info"))
                }
                close()
            }
            close()
        }
    }

    fun save(h: String, t: Long, i: String) {
        app.conn.prepareStatement("update DeckInCategory set timeinfo = ?, info = ? where hash = ?").apply {
            setLong(1, t)
            setString(2, i)
            setString(3, h)
            if (executeUpdate() != 1) {
                app.conn.prepareStatement("insert into DeckInCategory(hash, timeinfo, info) values(?, ?, ?)").apply {
                    setString(1, h)
                    setLong(2, t)
                    setString(3, i)
                    executeUpdate()
                    close()
                }
            }
            close()
        }
    }

}

class DeckTable(private val app: Application) {
    fun loadCache() {
        app.conn.prepareStatement("select code, timeinfo, info from Deck").apply {
            executeQuery().apply {
                forEach {
                    cacheDeck[it.string("code")] = Deck2(it.long("timeinfo"), it.string("info"))
                }
                close()
            }
            close()
        }
    }

    fun save(c: String, t: Long, i: String) {
        app.conn.prepareStatement("update Deck set timeinfo = ?, info = ? where code = ?").apply {
            setLong(1, t)
            setString(2, i)
            setString(3, c)
            if (executeUpdate() != 1) {
                app.conn.prepareStatement("insert into Deck(code, timeinfo, info) values(?, ?, ?)").apply {
                    setString(1, c)
                    setLong(2, t)
                    setString(3, i)
                    executeUpdate()
                    close()
                }
            }
            close()
        }
    }
}

val Application.deckTheme: DeckTheme get() = DeckTheme(this)
val Application.deckCategory: DeckCategory get() = DeckCategory(this)
val Application.deckInCategory: DeckInCategory get() = DeckInCategory(this)
val Application.deckTable: DeckTable get() = DeckTable(this)