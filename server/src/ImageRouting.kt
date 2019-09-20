package com.rarnu.ygo.server

import com.rarnu.ktor.save
import com.rarnu.ygo.server.cardimage.ImageRequest2
import com.rarnu.ygo.server.common.imgTmpPath
import io.ktor.application.application
import io.ktor.application.call
import io.ktor.request.receiveMultipart
import io.ktor.response.respondText
import io.ktor.routing.Routing
import io.ktor.routing.post
import io.ktor.util.pipeline.ContextDsl
import java.io.File
import java.util.*

@ContextDsl
fun Routing.imageRouting() {

    post("/matchimage") {
        val f = File(imgTmpPath, UUID.randomUUID().toString())
        call.receiveMultipart().save("file", f)
        ImageRequest2.matchImage(application, f) {
            call.respondText { it }
        }

    }
}