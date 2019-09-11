@file:Suppress("DuplicatedCode")

package com.rarnu.ygo.server.account

import com.rarnu.ktor.config
import com.rarnu.ktor.decodeURLPart
import com.rarnu.ygo.server.database.accountTable
import com.rarnu.ygo.server.request.differentMinutesByMillisecond
import io.ktor.application.Application
import org.apache.commons.mail.SimpleEmail
import java.util.*
import kotlin.random.Random

object AccountRequest2 {
    suspend fun getUserInfo(app: Application, userId: Long, callback: suspend (String) -> Unit) {
        if (userId == 0L) {
            callback("{\"id\":0}")
        } else {
            val u = cacheAccount[userId]
            if (u == null) {
                callback("{\"id\":0}")
            } else {
                callback("{\"id\":${u.id},\"account\":\"${u.account}\",\"nickname\":\"${u.nickname}\",\"headimg\":\"${u.headimg}\",\"email\":\"${u.email.decodeURLPart()}\"}")
            }
        }
    }

    suspend fun userLogin(app: Application, account: String, password: String, callback: suspend (Long, String) -> Unit) {
        val u = cacheAccount.values.firstOrNull { it.account == account && it.password == password }
        if (u == null) {
            callback(0L, "{\"id\":0}")
        } else {
            callback(u.id, "{\"id\":${u.id},\"account\":\"${u.account}\",\"nickname\":\"${u.nickname}\",\"headimg\":\"${u.headimg}\",\"email\":\"${u.email.decodeURLPart()}\"}")
        }
    }

    suspend fun userRegister(app: Application, account: String, password: String, nickname: String, email: String, callback: suspend (Long, String) -> Unit) {
        val u = cacheAccount.values.firstOrNull { it.account == account }
        if (u == null) {
            // register
            val rid = app.accountTable.save(account, password, nickname, email)
            if (rid == 0L) {
                callback(0L, "{\"id\":0}")
            } else {
                val usr = AccountCache2(rid, account, password, nickname, "default.png", email)
                cacheAccount[rid] = usr
                callback(usr.id, "{\"id\":${usr.id},\"account\":\"${usr.account}\",\"nickname\":\"${usr.nickname}\",\"headimg\":\"${usr.headimg}\",\"email\":\"${usr.email.decodeURLPart()}\"}")
            }
        } else {
            callback(0L, "{\"id\":0}")
        }
    }

    suspend fun sendValidateCode(app: Application, account: String, callback: suspend (String) -> Unit) {
        var email = cacheAccount.values.firstOrNull { it.account == account }?.email ?: ""
        if (email == "") {
            callback("{\"result\":1}")
            return
        }
        email = email.decodeURLPart()
        val code = Random.nextInt(100000, 999999).toString()
        cacheValidateCode[account] = ValidateCode2(code, System.currentTimeMillis())
        val myEmail = app.config("ktor.mail.email")
        try {
            SimpleEmail().apply {
                hostName = app.config("ktor.mail.host")
                sslSmtpPort = app.config("ktor.mail.port")
                isSSLOnConnect = true
                setAuthentication(myEmail, app.config("ktor.mail.password"))
                setFrom(myEmail, app.config("ktor.mail.hostname"))
                addTo(email)
                setCharset("UTF-8")
                subject = "Reset Your Password"
                setMsg("Your Validate Code: $code")
                sentDate = Date()
            }.send()
            callback("{\"result\":0}")
        } catch (e: Exception) {
            println("error => $e")
            callback("{\"result\":1}")
        }
    }

    private fun checkValidateCode(account: String, code: String): Boolean {
        val v = cacheValidateCode[account]
        var ret = false
        if (v != null) {
            if (v.code == code && differentMinutesByMillisecond(System.currentTimeMillis(), v.time) < 10) {
                ret = true
            }
            cacheValidateCode.remove(account)
        }
        return ret
    }

    suspend fun updateUser(app: Application, userId: Long, nickname: String, email: String, callback: suspend (String) -> Unit) {
        val u = cacheAccount[userId]
        var ret = false
        if (u != null) {
            u.nickname = nickname
            u.email = email
            ret = app.accountTable.update(u.account, u.password, u.nickname, u.email)
        }
        callback("{\"result\":${if (ret) 0 else 1}}")
    }

    suspend fun updateHead(app: Application, userId: Long, head: String, callback: suspend (String) -> Unit) {
        val u = cacheAccount[userId]
        var ret = false
        if (u != null) {
            u.headimg = head
            ret = app.accountTable.headimage(u.account, u.headimg)
        }
        callback("{\"result\":${if (ret) 0 else 1}}")
    }

    suspend fun changePassword(app: Application, userId: Long, oldPwd: String, newPwd: String, callback: suspend (String) -> Unit) {
        val u = cacheAccount[userId]
        var ret = false
        if (u != null) {
            if (u.password == oldPwd) {
                u.password = newPwd
                ret = app.accountTable.update(u.account, u.password, u.nickname, u.email)
            }
        }
        callback("{\"result\":${if (ret) 0 else 1}}")
    }

    suspend fun resetPassword(app: Application, account: String, code: String, newPwd: String, callback: suspend (String) -> Unit) {
        var ret = false
        if (checkValidateCode(account, code)) {
            val u = cacheAccount.values.firstOrNull { it.account == account }
            if (u != null) {
                u.password = newPwd
                ret = app.accountTable.update(u.account, u.password, u.nickname, u.email)
            }
        }
        callback("{\"result\":${if (ret) 0 else 1}}")
    }
}