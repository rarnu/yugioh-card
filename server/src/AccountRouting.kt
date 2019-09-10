package com.rarnu.ygo.server

import com.rarnu.ktor.requestParameters
import com.rarnu.ygo.server.account.AccountRequest2
import io.ktor.application.application
import io.ktor.application.call
import io.ktor.request.receiveParameters
import io.ktor.response.respondText
import io.ktor.routing.Routing
import io.ktor.routing.get
import io.ktor.routing.post
import io.ktor.util.KtorExperimentalAPI
import io.ktor.util.pipeline.ContextDsl

@KtorExperimentalAPI
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
        // TODO: update user
    }

    post("/resetpassword") {
        // TODO: reset password
    }

    get("/sendvalidatecode") {
        val p = call.requestParameters()
        val account = p["account"] ?: ""
        val ret = AccountRequest2.sendValidateCode(account)
        call.respondText { "{\"result\":${if (ret) 0 else 1}}" }
    }

    post("/checkvalidatecode") {
        val p = call.requestParameters()
        val account = p["account"] ?: ""
        val code = p["code"] ?: ""
        val ret = AccountRequest2.checkValidateCode(account, code)
        call.respondText { "{\"result\":${if (ret) 0 else 1}}" }
    }

    post("/uploadhead") {
        // TODO: upload header
    }

    get("/gethead") {
        // TODO: get header
    }

    get("/getuser") {
        AccountRequest2.getUserInfo(application, localSession.userId) {
            call.respondText { it }
        }
    }

}