@file:Suppress("SqlDialectInspection", "DuplicatedCode")

package com.rarnu.ygo.server.database

import com.rarnu.common.forEach
import com.rarnu.common.int
import com.rarnu.common.long
import com.rarnu.common.string
import com.rarnu.ktor.conn
import com.rarnu.ygo.server.collect.Collect2
import io.ktor.application.Application

class CollectTable(private val app: Application) {

    fun collectCard(userid: Long, name: String, cardhash: String) =
        app.conn.prepareStatement("insert into Collect(userid, type, collectname, cardhash, deckdata, timeinfo) values (?,0,?,?,'',?)").use { s ->
            s.setLong(1, userid)
            s.setString(2, name)
            s.setString(3, cardhash)
            s.setLong(4, System.currentTimeMillis())
            s.executeUpdate() > 0
        }

    fun uncollectCard(userid: Long, cardhash: String) =
        app.conn.prepareStatement("delete from Collect where userid = ? and cardhash = ?").use { s ->
            s.setLong(1, userid)
            s.setString(2, cardhash)
            s.executeUpdate() > 0
        }

    fun collectDeck(userid: Long, name: String, deckdata: String) =
        app.conn.prepareStatement("insert into Collect(userid, type, collectname, cardhash, deckdata, timeinfo) values (?,1,?,'',?,?)").use { s ->
            s.setLong(1, userid)
            s.setString(2, name)
            s.setString(3, deckdata)
            s.setLong(4, System.currentTimeMillis())
            s.executeUpdate() > 0
        }

    fun uncollectDeck(userid: Long, deckdata: String) =
        app.conn.prepareStatement("delete from Collect where userid = ? and deckdata = ?").use { s ->
            s.setLong(1, userid)
            s.setString(2, deckdata)
            s.executeUpdate() > 0
        }

    fun get(id: Long) =
        app.conn.prepareStatement("select * from Collect where id = ?").use { s ->
            s.setLong(1, id)
            s.executeQuery().use { r ->
                if (r.first()) {
                    Collect2(
                        r.long("id"),
                        r.long("userid"),
                        r.int("type"),
                        r.string("collectname"),
                        r.string("cardhash"),
                        r.string("deckdata"),
                        r.long("timeinfo")
                    )
                } else null
            }
        }

    fun getCardCollection(userid: Long, cardhash: String) =
        app.conn.prepareStatement("select * from Collect where userid = ? and cardhash = ?").use { s ->
            s.setLong(1, userid)
            s.setString(2, cardhash)
            s.executeQuery().use { r ->
                if (r.first()) {
                    Collect2(
                        r.long("id"),
                        r.long("userid"),
                        r.int("type"),
                        r.string("collectname"),
                        r.string("cardhash"),
                        r.string("deckdata"),
                        r.long("timeinfo")
                    )
                } else null
            }
        }

    fun getDeckCollection(userid: Long, deckdata: String) =
        app.conn.prepareStatement("select * from Collect where userid = ? and deckdata = ?").use { s ->
            s.setLong(1, userid)
            s.setString(2, deckdata)
            s.executeQuery().use { r ->
                if (r.first()) {
                    Collect2(
                        r.long("id"),
                        r.long("userid"),
                        r.int("type"),
                        r.string("collectname"),
                        r.string("cardhash"),
                        r.string("deckdata"),
                        r.long("timeinfo")
                    )
                } else null
            }
        }

    fun getRecent(userid: Long) = mutableListOf<Collect2>().apply {
        app.conn.prepareStatement("select * from Collect where userid = ? order by id desc limit 0, 20").use { s ->
            s.setLong(1, userid)
            s.executeQuery().use { r ->
                r.forEach {
                    add(
                        Collect2(
                            it.long("id"),
                            it.long("userid"),
                            it.int("type"),
                            it.string("collectname"),
                            it.string("cardhash"),
                            it.string("deckdata"),
                            it.long("timeinfo")
                        )
                    )
                }
            }
        }
    }.toList()

    fun getTyped(userid: Long, type: Int) = mutableListOf<Collect2>().apply {
        app.conn.prepareStatement("select * from Collect where userid = ? and type = ? order by id desc").use { s ->
            s.setLong(1, userid)
            s.setInt(2, type)
            s.executeQuery().use { r ->
                r.forEach {
                    add(
                        Collect2(
                            it.long("id"),
                            it.long("userid"),
                            it.int("type"),
                            it.string("collectname"),
                            it.string("cardhash"),
                            it.string("deckdata"),
                            it.long("timeinfo")
                        )
                    )
                }
            }
        }
    }.toList()

}

val Application.collectTable: CollectTable get() = CollectTable(this)