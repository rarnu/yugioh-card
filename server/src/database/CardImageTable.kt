@file:Suppress("SqlDialectInspection")

package com.rarnu.ygo.server.database

import com.github.kilianB.hash.Hash
import com.rarnu.common.forEach
import com.rarnu.common.int
import com.rarnu.common.string
import com.rarnu.ktor.config
import com.rarnu.ktor.conn
import com.rarnu.ygo.server.cardimage.cardImageCache
import io.ktor.application.Application

class CardImageTable(private val app: Application) {
    fun loadCache() {
        val len = app.config("ktor.image.hashlength").toInt()
        val algid = app.config("ktor.image.algid").toInt()
        app.conn.prepareStatement("select * from ImageHash").use { s ->
            s.executeQuery().use { r ->
                r.forEach {
                    cardImageCache[Hash(it.string("hashcode").toBigInteger(), len, algid)] = it.int("cardid")
                }
            }
        }
    }
}

val Application.cardImageTable: CardImageTable get() = CardImageTable(this)