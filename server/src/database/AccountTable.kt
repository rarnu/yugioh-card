@file:Suppress("DuplicatedCode", "SqlDialectInspection")

package com.rarnu.ygo.server.database

import com.rarnu.common.firstRecord
import com.rarnu.common.forEach
import com.rarnu.common.long
import com.rarnu.common.string
import com.rarnu.ktor.conn
import com.rarnu.ygo.server.account.AccountCache2
import com.rarnu.ygo.server.account.cacheAccount
import io.ktor.application.Application

class AccountTable(private val app: Application) {
    fun loadCache() {
        app.conn.prepareStatement("select id, account, password, nickname, headimg, email from Users").apply {
            executeQuery().apply {
                forEach {
                    cacheAccount[it.long("id")] = AccountCache2(
                        it.long("id"),
                        it.string("account"),
                        it.string("password"),
                        it.string("nickname"),
                        it.string("headimg"),
                        it.string("email")
                    )
                }
                close()
            }
            close()
        }
    }

    fun save(account: String, password: String, nickname: String, email: String) =
        app.conn.prepareStatement("insert into Users(account, password, nickname, email) values (?, ?, ?, ?)").run {
            setString(1, account)
            setString(2, password)
            setString(3, nickname)
            setString(4, email)
            var ret = 0L
            if (executeUpdate() > 0) {
                app.conn.prepareStatement("select id from Users where account = ? and password = ?").apply {
                    setString(1, account)
                    setString(2, password)
                    executeQuery().apply {
                        firstRecord {
                            ret = it.long("id")
                        }
                        close()
                    }
                    close()
                }
            }
            close()
            ret
        }


    fun update(account: String, password: String, nickname: String, email: String) =
        app.conn.prepareStatement("update Users set password = ?, nickname = ?, email = ?  where account = ?").run {
            setString(1, password)
            setString(2, nickname)
            setString(3, email)
            setString(4, account)
            val ret = executeUpdate() > 0
            close()
            ret
        }


    fun headimage(account: String, headimg: String) =
        app.conn.prepareStatement("update Users set headimg = ? where account = ?").run {
            setString(1, headimg)
            setString(2, account)
            val ret = executeUpdate() > 0
            close()
            ret
        }

}

val Application.accountTable: AccountTable get() = AccountTable(this)