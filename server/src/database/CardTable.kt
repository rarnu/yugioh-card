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
        app.conn.prepareStatement("select hash, timeinfo, data, adjust, wiki from Card").apply {
            executeQuery().apply {
                forEach {
                    cacheMap[it.string("hash")] =
                        CardCache2(it.string("data"), it.string("adjust"), it.string("wiki"), it.long("timeinfo"))
                }
                close()
            }
            close()
        }
    }

    fun save(h: String, t: Long, d: String, a: String, w: String) {
        app.conn.prepareStatement("insert into Card(hash, timeinfo, data, adjust, wiki) values (?, ?, ?, ?, ?)").apply {
            setString(1, h)
            setLong(2, t)
            setString(3, d)
            setString(4, a)
            setString(5, w)
            executeUpdate()
            close()
        }
    }

    fun update(h: String, t: Long, d: String, a: String, w: String) {
        app.conn.prepareStatement("update Card set data = ?, adjust = ?, wiki = ?, timeinfo = ? where hash = ?").apply {
            setString(1, d)
            setString(2, a)
            setString(3, w)
            setLong(4, t)
            setString(5, h)
            executeUpdate()
            close()
        }
    }
}

class CardLimit(private val app: Application) {
    fun loadCache() {
        app.conn.prepareStatement("select timeinfo, info from CardLimit").apply {
            executeQuery().apply {
                firstRecord {
                    cacheLimit.timeinfo = it.long("timeinfo")
                    cacheLimit.text = it.string("info")
                }
                close()
            }
            close()
        }
    }

    fun save(t: Long, i: String) {
        app.conn.prepareStatement("update CardLimit set timeinfo = ?, info = ?").apply {
            setLong(1, t)
            setString(2, i)
            if (executeUpdate() != 1) {
                app.conn.prepareStatement("insert into CardLimit(timeinfo, info) values(?, ?)").apply {
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

class CardPack(private val app: Application) {
    fun loadCache() {
        app.conn.prepareStatement("select timeinfo, info from CardPack").apply {
            executeQuery().apply {
                firstRecord {
                    cachePack.timeinfo = it.long("timeinfo")
                    cachePack.text = it.string("info")
                }
                close()
            }
            close()
        }
    }

    fun save(t: Long, i: String) {
        app.conn.prepareStatement("update CardPack set timeinfo = ?, info = ?").apply {
            setLong(1, t)
            setString(2, i)
            if (executeUpdate() != 1) {
                app.conn.prepareStatement("insert into CardPack(timeinfo, info) values(?, ?)").apply {
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

class CardPackDetail(private val app: Application) {
    fun loadCache() {
        app.conn.prepareStatement("select url, info, timeinfo from CardPackDetail").apply {
            executeQuery().apply {
                forEach {
                    cachePackDetail[it.string("url")] = CardDetail2(it.long("timeinfo"), it.string("info"))
                }
                close()
            }
            close()
        }
    }

    fun save(u: String, t: Long, i: String) {
        app.conn.prepareStatement("update CardPackDetail set info = ?, timeinfo = ? where url = ?").apply {
            setString(1, i)
            setLong(2, t)
            setString(3, u)
            if (executeUpdate() != 1) {
                app.conn.prepareStatement("insert into CardPackDetail(url, info, timeinfo) values(?, ?, ?)").apply {
                    setString(1, u)
                    setString(2, i)
                    setLong(3, t)
                    executeUpdate()
                    close()
                }
            }
            close()
        }
    }
}

val Application.cardTable: CardTable get() = CardTable(this)
val Application.limitTable: CardLimit get() = CardLimit(this)
val Application.packTable: CardPack get() = CardPack(this)
val Application.packDetailTable: CardPackDetail get() = CardPackDetail(this)
