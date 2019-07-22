package com.rarnu.ygo.server

import com.rarnu.ktor.session
import io.ktor.application.ApplicationCall
import io.ktor.util.pipeline.PipelineContext
import java.util.*

data class ServerSession(val uuid: String)

inline val PipelineContext<*, ApplicationCall>.localSession: ServerSession
    get() = session {
        ServerSession(UUID.randomUUID().toString())
    }
