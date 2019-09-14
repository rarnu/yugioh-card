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

    fun collect(userid: Long, type: Int, name: String, cardhash: String, deckdata: String) =
        app.conn.prepareStatement("insert into Collect(userid, type, collectname, cardhash, deckdata, timeinfo) values (?,?,?,?,?,?)").use { s ->
            s.setLong(1, userid)
            s.setInt(2, type)
            s.setString(3, name)
            s.setString(4, cardhash)
            s.setString(5, deckdata)
            s.setLong(6, System.currentTimeMillis())
            s.executeUpdate() > 0
        }

    fun uncollect(userid: Long, type: Int, name: String) =
        app.conn.prepareStatement("delete from Collect where userid = ? and type = ? and collectname = ?").use { s ->
            s.setLong(1, userid)
            s.setInt(2, type)
            s.setString(3, name)
            s.executeUpdate() > 0
        }

    fun getCollected(userid: Long, type: Int, name: String) =
        app.conn.prepareStatement("select count(*) as 'count' from Collect where userid = ? and type = ? and collectname = ?").use { s ->
            s.setLong(1, userid)
            s.setInt(2, type)
            s.setString(3, name)
            s.executeQuery().use { r ->
                r.first()
                r.int("count") != 0
            }
        }

    fun get(id: Long): Collect2? =
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
                } else {
                    null
                }
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