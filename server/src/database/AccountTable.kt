@file:Suppress("DuplicatedCode", "SqlDialectInspection")

package com.rarnu.ygo.server.database

import com.rarnu.common.forEach
import com.rarnu.common.long
import com.rarnu.common.string
import com.rarnu.ktor.conn
import com.rarnu.ygo.server.account.AccountCache2
import com.rarnu.ygo.server.account.cacheAccount
import io.ktor.application.Application

class AccountTable(private val app: Application) {
    fun loadCache() =
        app.conn.prepareStatement("select id, account, password, nickname, headimg, email, wxid from Users").use { s ->
            s.executeQuery().use { r ->
                r.forEach {
                    cacheAccount[it.long("id")] = AccountCache2(
                        it.long("id"),
                        it.string("account"),
                        it.string("password"),
                        it.string("nickname"),
                        it.string("headimg"),
                        it.string("email"),
                        it.string("wxid")
                    )
                }
            }
        }


    fun save(account: String, password: String, nickname: String, email: String) =
        app.conn.prepareStatement("insert into Users(account, password, nickname, email) values (?, ?, ?, ?)").use { s ->
            s.setString(1, account)
            s.setString(2, password)
            s.setString(3, nickname)
            s.setString(4, email)
            var ret = 0L
            if (s.executeUpdate() > 0) {
                app.conn.prepareStatement("select id from Users where account = ? and password = ?").use { s2 ->
                    s2.setString(1, account)
                    s2.setString(2, password)
                    s2.executeQuery().use { r ->
                        if (r.first()) {
                            ret = r.long("id")
                        }
                    }
                }
            }
            ret
        }

    fun saveWx(wxid: String) =
        app.conn.prepareStatement("insert into Users(account, password, nickname, email, wxid) values (?, ?, '', '', ?)").use { s ->
            s.setString(1, wxid)
            s.setString(2, wxid)
            s.setString(3, wxid)
            var ret = 0L
            if (s.executeUpdate() > 0) {
               app.conn.prepareStatement("select id from Users where wxid = ?").use { s2 ->
                   s2.setString(1, wxid)
                   s2.executeQuery().use { r ->
                       if (r.first()) {
                           ret = r.long("id")
                       }
                   }
               }
            }
            ret
        }

    fun update(account: String, password: String, nickname: String, email: String) =
        app.conn.prepareStatement("update Users set password = ?, nickname = ?, email = ?  where account = ?").use { s ->
            s.setString(1, password)
            s.setString(2, nickname)
            s.setString(3, email)
            s.setString(4, account)
            s.executeUpdate() > 0
        }

    fun headimage(account: String, headimg: String) =
        app.conn.prepareStatement("update Users set headimg = ? where account = ?").use { s ->
            s.setString(1, headimg)
            s.setString(2, account)
            s.executeUpdate() > 0
        }

}

val Application.accountTable: AccountTable get() = AccountTable(this)