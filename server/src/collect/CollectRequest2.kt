package com.rarnu.ygo.server.collect

import com.rarnu.ygo.server.database.collectTable
import io.ktor.application.Application


object CollectRequest2 {
    suspend fun isCardCollected(app: Application, userId: Long, cardhash: String, callback:suspend (String) -> Unit) {
        val ret = app.collectTable.getCardCollection(userId, cardhash)
        if (ret == null) {
            callback("{\"result\":1}")
        } else {
            callback("{\"result\":0, \"id\":${ret.id}}")
        }
    }

    suspend fun isDeckCollected(app: Application, userId: Long, deckdata: String, callback: suspend (String) -> Unit) {
        val ret = app.collectTable.getDeckCollection(userId, deckdata)
        if (ret == null) {
            callback("{\"result\":1}")
        } else {
            callback("{\"result\":0, \"id\":${ret.id}}")
        }
    }

    suspend fun collectCard(app: Application, userId: Long, cardhash: String, name: String, callback: suspend (String) -> Unit) {
        val ret = app.collectTable.collectCard(userId, name, cardhash)
        callback("{\"result\":${if (ret) 0 else 1}}")
    }

    suspend fun uncollectCard(app: Application, userId: Long, cardhash: String, callback: suspend (String) -> Unit) {
        val ret = app.collectTable.uncollectCard(userId, cardhash)
        callback("{\"result\":${if (ret) 0 else 1}}")
    }

    suspend fun collectDeck(app: Application, userId: Long, deckdata: String, name: String, callback: suspend (String) -> Unit) {
        val ret = app.collectTable.collectDeck(userId, name, deckdata)
        callback("{\"result\":${if (ret) 0 else 1}}")
    }

    suspend fun uncollectDeck(app: Application, userId: Long, deckdata: String, callback: suspend (String) -> Unit) {
        val ret = app.collectTable.uncollectDeck(userId, deckdata)
        callback("{\"result\":${if (ret) 0 else 1}}")
    }

    suspend fun getRecentCollect(app: Application, userId: Long, callback: suspend (String) -> Unit) {
        val list = app.collectTable.getRecent(userId)
        callback(list.toJSon())
    }

    suspend fun getCardCollect(app: Application, userId: Long, callback: suspend (String) -> Unit) {
        val list = app.collectTable.getTyped(userId, 0)
        callback(list.toJSon())
    }

    suspend fun getDeckCollect(app: Application, userId: Long, callback: suspend (String) -> Unit) {
        val list = app.collectTable.getTyped(userId, 1)
        callback(list.toJSon())
    }
}