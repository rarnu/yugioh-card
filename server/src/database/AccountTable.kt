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
import java.lang.Exception

class AccountTable(private val app: Application) {
    fun loadCache() {
        val stmt = app.conn.prepareStatement("select id, account, password, nickname, headimg, email from Users")
        val rs = stmt.executeQuery()
        rs.forEach {
            cacheAccount[it.long("id")] = AccountCache2(it.long("id"), it.string("account"), it.string("password"), it.string("nickname"), it.string("headimg"), it.string("email"))
        }
        rs.close()
        stmt.close()
    }

    fun save(account: String, password: String, nickname: String, email: String): Long {
        val stmt = app.conn.prepareStatement("insert into Users(account, password, nickname, email) values (?, ?, ?, ?)")
        stmt.setString(1, account)
        stmt.setString(2, password)
        stmt.setString(3, nickname)
        stmt.setString(4, email)
        try {
            return if (stmt.executeUpdate() > 0) {
                val stmtSel = app.conn.prepareStatement("select id from Users where account = ? and password = ?")
                stmtSel.setString(1, account)
                stmtSel.setString(2, password)
                val rs = stmtSel.executeQuery()
                var rId = 0L
                rs.firstRecord {
                    rId = it.long("id")
                }
                rs.close()
                rId
            } else {
                0L
            }
        } catch (e: Exception) {
            return 0L
        } finally {
            stmt.close()
        }
    }

    fun update(account: String, password: String, nickname: String, email: String): Boolean {
        val stmt = app.conn.prepareStatement("update Users set password = ?, nickname = ?, email = ?  where account = ?")
        stmt.setString(1, password)
        stmt.setString(2, nickname)
        stmt.setString(3, email)
        stmt.setString(4, account)
        return try {
            stmt.executeUpdate() > 0
        } catch (e: Throwable) {
            false
        } finally {
            stmt.close()
        }
    }

    fun headimage(account: String, headimg: String): Boolean {
        val stmt = app.conn.prepareStatement("update Users set headimg = ? where account = ?")
        stmt.setString(1, headimg)
        stmt.setString(2, account)
        return try {
            stmt.executeUpdate() > 0
        } catch (e: Throwable) {
            false
        } finally {
            stmt.close()
        }
    }
}

val Application.accountTable: AccountTable get() = AccountTable(this)