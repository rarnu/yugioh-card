package com.rarnu.ygo.server

import com.rarnu.ktor.requestParameters
import com.rarnu.ktor.resolveFileBytes
import com.rarnu.ktor.save
import com.rarnu.ygo.server.account.AccountRequest2
import com.rarnu.ygo.server.common.headPath
import io.ktor.application.application
import io.ktor.application.call
import io.ktor.request.receiveMultipart
import io.ktor.response.respondBytes
import io.ktor.response.respondText
import io.ktor.routing.Routing
import io.ktor.routing.get
import io.ktor.routing.post
import io.ktor.util.pipeline.ContextDsl
import java.io.File

@ContextDsl
fun Routing.accountRouting() {

    post("/login") {
        val p = call.requestParameters()
        val account = p["account"] ?: ""
        val password = p["password"] ?: ""
        AccountRequest2.userLogin(application, account, password) { uid, content ->
            localSession.userId = uid
            call.respondText { content }
        }
    }

    get("/logout") {
        localSession.userId = 0L
        call.respondText { "{\"result\":0}" }
    }

    post("/register") {
        val p = call.requestParameters()
        val account = p["account"] ?: ""
        val password = p["password"] ?: ""
        val nickname = p["nickname"] ?: ""
        val email = p["email"] ?: ""
        AccountRequest2.userRegister(application, account, password, nickname, email) { uid, content ->
            localSession.userId = uid
            call.respondText { content }
        }
    }

    post("/updateuser") {
        val p = call.requestParameters()
        val nickname = p["nickname"] ?: ""
        val email = p["email"] ?: ""
        AccountRequest2.updateUser(application, localSession.userId, nickname, email) {
            call.respondText { it }
        }
    }

    post("/changepassword") {
        val p = call.requestParameters()
        val oldpwd = p["oldpwd"] ?: ""
        val newpwd = p["newpwd"] ?: ""
        AccountRequest2.changePassword(application, localSession.userId, oldpwd, newpwd) {
            call.respondText { it }
        }
    }

    /**
     * 重置密码时需要带着验证码
     */
    post("/resetpassword") {
        val p = call.requestParameters()
        val account = p["account"] ?: ""
        val code = p["code"] ?: ""
        val newpwd = p["newpwd"] ?: ""
        AccountRequest2.resetPassword(application, account, code, newpwd) {
            call.respondText { it }
        }
    }

    /**
     * 重置密码前先发验证码
     */
    get("/sendvalidatecode") {
        val p = call.requestParameters()
        val account = p["account"] ?: ""
        AccountRequest2.sendValidateCode(application, account) {
            call.respondText { it }
        }

    }

    post("/uploadhead") {
        call.receiveMultipart().save("file", File(headPath, localSession.userId.toString()))
        AccountRequest2.updateHead(application, localSession.userId, localSession.userId.toString()) {
            call.respondText { it }
        }
    }

    get("/gethead") {
        val localFile = File(headPath, localSession.userId.toString())
        call.respondBytes { if (localFile.exists()) localFile.readBytes() else call.resolveFileBytes("static/image/logo.png")!! }
    }

    get("/getuser") {
        AccountRequest2.getUserInfo(application, localSession.userId) {
            call.respondText { it }
        }
    }

}