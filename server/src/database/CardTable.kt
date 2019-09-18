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
    fun loadCache() =
        app.conn.prepareStatement("select * from Card").use { s ->
            s.executeQuery().use { r ->
                r.forEach {
                    cacheMap[it.string("hash")] =
                        CardCache2(it.string("data"), it.string("adjust"), it.string("wiki"), it.long("timeinfo"), it.string("nwname"))
                }
            }
        }


    fun save(h: String, t: Long, d: String, a: String, w: String, nwn: String) {
        if (!update(h, t, d, a, w, nwn)) {
            app.conn.prepareStatement("insert into Card(hash, timeinfo, data, adjust, wiki, nwname) values (?, ?, ?, ?, ?, ?)")
                .use { s ->
                    s.setString(1, h)
                    s.setLong(2, t)
                    s.setString(3, d)
                    s.setString(4, a)
                    s.setString(5, w)
                    s.setString(6, nwn)
                    s.executeUpdate()
                }
        }
    }

    fun update(h: String, t: Long, d: String, a: String, w: String, nwn: String) =
        app.conn.prepareStatement("update Card set data = ?, adjust = ?, wiki = ?, timeinfo = ?, nwname = ? where hash = ?")
            .use { s ->
                s.setString(1, d)
                s.setString(2, a)
                s.setString(3, w)
                s.setLong(4, t)
                s.setString(5, nwn)
                s.setString(6, h)
                s.executeUpdate() > 0
            }

}

class CardLimit(private val app: Application) {
    fun loadCache() =
        app.conn.prepareStatement("select timeinfo, info from CardLimit").use { s ->
            s.executeQuery().use { r ->
                r.firstRecord {
                    cacheLimit.timeinfo = it.long("timeinfo")
                    cacheLimit.text = it.string("info")
                }
            }
        }

    fun save(t: Long, i: String) =
        app.conn.prepareStatement("update CardLimit set timeinfo = ?, info = ?").use { s ->
            s.setLong(1, t)
            s.setString(2, i)
            if (s.executeUpdate() != 1) {
                app.conn.prepareStatement("insert into CardLimit(timeinfo, info) values(?, ?)").use { s2 ->
                    s2.setLong(1, t)
                    s2.setString(2, i)
                    s2.executeUpdate()
                }
            }
        }
}

class CardPack(private val app: Application) {
    fun loadCache() =
        app.conn.prepareStatement("select timeinfo, info from CardPack").use { s ->
            s.executeQuery().use { r ->
                r.firstRecord {
                    cachePack.timeinfo = it.long("timeinfo")
                    cachePack.text = it.string("info")
                }
            }
        }

    fun save(t: Long, i: String) =
        app.conn.prepareStatement("update CardPack set timeinfo = ?, info = ?").use { s ->
            s.setLong(1, t)
            s.setString(2, i)
            if (s.executeUpdate() != 1) {
                app.conn.prepareStatement("insert into CardPack(timeinfo, info) values(?, ?)").use { s2 ->
                    s2.setLong(1, t)
                    s2.setString(2, i)
                    s2.executeUpdate()
                }
            }
        }

}

class CardPackDetail(private val app: Application) {
    fun loadCache() =
        app.conn.prepareStatement("select url, info, timeinfo from CardPackDetail").use { s ->
            s.executeQuery().use { r ->
                r.forEach {
                    cachePackDetail[it.string("url")] = CardDetail2(it.long("timeinfo"), it.string("info"))
                }
            }
        }

    fun save(u: String, t: Long, i: String) =
        app.conn.prepareStatement("update CardPackDetail set info = ?, timeinfo = ? where url = ?").use { s ->
            s.setString(1, i)
            s.setLong(2, t)
            s.setString(3, u)
            if (s.executeUpdate() != 1) {
                app.conn.prepareStatement("insert into CardPackDetail(url, info, timeinfo) values(?, ?, ?)").use { s2 ->
                    s2.setString(1, u)
                    s2.setString(2, i)
                    s2.setLong(3, t)
                    s2.executeUpdate()
                }
            }
        }

}

val Application.cardTable: CardTable get() = CardTable(this)
val Application.limitTable: CardLimit get() = CardLimit(this)
val Application.packTable: CardPack get() = CardPack(this)
val Application.packDetailTable: CardPackDetail get() = CardPackDetail(this)
