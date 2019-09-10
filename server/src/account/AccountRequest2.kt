@file:Suppress("DuplicatedCode")

package com.rarnu.ygo.server.account

import com.rarnu.ygo.server.database.accountTable
import com.rarnu.ygo.server.request.differentMinutesByMillisecond
import io.ktor.application.Application
import io.ktor.http.decodeURLPart
import io.ktor.util.KtorExperimentalAPI
import org.apache.commons.mail.SimpleEmail
import java.lang.Exception
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
                callback("{\"id\":${u.id},\"account\":\"${u.account}\",\"nickname\":\"${u.nickname}\",\"headimg\":\"${u.headimg}\",\"email\":\"${u.email}\"}")
            }
        }
    }


    suspend fun userLogin(app: Application, account: String, password: String, callback: suspend (Long, String) -> Unit) {
        val u = cacheAccount.values.firstOrNull { it.account == account && it.password == password }
        if (u == null) {
            callback(0L, "{\"id\":0}")
        } else {
            callback(u.id, "{\"id\":${u.id},\"account\":\"${u.account}\",\"nickname\":\"${u.nickname}\",\"headimg\":\"${u.headimg}\",\"email\":\"${u.email}\"}")
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
                callback(usr.id, "{\"id\":${usr.id},\"account\":\"${usr.account}\",\"nickname\":\"${usr.nickname}\",\"headimg\":\"${usr.headimg}\",\"email\":\"${usr.email}\"}")
            }
        } else {
            callback(0L, "{\"id\":0}")
        }
    }



    @KtorExperimentalAPI
    fun sendValidateCode(account: String): Boolean {
        var email = cacheAccount.values.firstOrNull { it.account == account }?.email ?: ""
        if (email == "") return false
        email = email.decodeURLPart()
        val code = Random.nextInt(100000, 999999).toString()
        cacheValidateCode[account] = ValidateCode2(code, System.currentTimeMillis())
        val myEmail = "123909566@qq.com"
        val myPass = "cmktaicmrfrrbibd"
        return try {
            SimpleEmail().apply {
                hostName = "smtp.qq.com"
                sslSmtpPort = "465"
                isSSLOnConnect = true
                setAuthentication(myEmail, myPass)
                setFrom(myEmail, "rarnu.xyz")
                addTo(email)
                setCharset("UTF-8")
                subject = "Reset Your Password"
                setMsg("Your Validate Code: $code")
                sentDate = Date()
            }.send()
            true
        } catch (e: Exception) {
            println("error => $e")
            false
        }
    }

    fun checkValidateCode(account: String, code: String): Boolean {
        val v = cacheValidateCode[account]
        var ret = false
        if (v != null) {
            if (v.code == code && differentMinutesByMillisecond(System.currentTimeMillis(), v.time) < 15) {
                ret = true
            }
            cacheValidateCode.remove(account)
        }
        return ret
    }
}