package com.rarnu.ygo.server.deck

import com.rarnu.ygo.server.database.deckCategory
import com.rarnu.ygo.server.database.deckInCategory
import com.rarnu.ygo.server.database.deckTable
import com.rarnu.ygo.server.database.deckTheme
import com.rarnu.ygo.server.request.dGetRequest
import com.rarnu.ygo.server.request.dPostRequest
import com.rarnu.ygo.server.request.differentDaysByMillisecond
import io.ktor.application.Application

private const val BASE_URL = "https://www.ygo-sem.cn/convention"
private const val BASE_DECK_URL = "https://www.ygo-sem.cn/Cards/Decks-%s.aspx"

object DeckRequest2 {

    suspend fun theme(app: Application, callback: suspend (String) -> Unit) {
        val txt = cacheDeckTheme.text
        val time = cacheDeckTheme.timeinfo
        val current = System.currentTimeMillis()
        if (txt == "" || differentDaysByMillisecond(current, time) > 30) {
            val theme = dGetRequest(app, "$BASE_URL/server.ashx?action=get_convention_books2").parseTheme()
            if (theme != "[]") {
                cacheDeckTheme.timeinfo = current
                cacheDeckTheme.text = theme
                app.deckTheme.save(current, theme)
            }
            callback(theme)
        } else {
            callback(txt)
        }
    }

    suspend fun category(app: Application, callback: suspend (String) -> Unit) {
        val txt = cacheDeckCategory.text
        val time = cacheDeckCategory.timeinfo
        val current = System.currentTimeMillis()
        if (txt == "" || differentDaysByMillisecond(current, time) > 30) {
            val category = dGetRequest(app, "$BASE_URL/server.ashx?action=convention_tree").parseCategory()
            if (category != "[]") {
                cacheDeckCategory.timeinfo = current
                cacheDeckCategory.text = category
                app.deckCategory.save(current, category)
            }
            callback(category)
        } else {
            callback(txt)
        }
    }

    suspend fun inCategory(app: Application, hash: String, callback: suspend (String) -> Unit) {
        val decks = cacheDeckInCategory[hash]
        val current = System.currentTimeMillis()
        if (decks == null || differentDaysByMillisecond(current, decks.timeinfo) > 30) {
            val incat = dPostRequest(app, "$BASE_URL/convention_content3.aspx?f=f", mapOf("id" to hash, "langue" to "chs")).parseInCategory()
            if (incat != "[]") {
                cacheDeckInCategory[hash] = DeckInCategory2(current, incat)
                app.deckInCategory.save(hash, current, incat)
            }
            callback(incat)
        } else {
            callback(decks.text)
        }
    }

    suspend fun deck(app: Application, code: String, callback: suspend (String) -> Unit) {
        val deck = cacheDeck[code]
        val current = System.currentTimeMillis()
        if (deck == null || differentDaysByMillisecond(current, deck.timeinfo) > 30) {
            val d = dGetRequest(app, BASE_DECK_URL.format(code)).parseDeck()
            if (d != "[]") {
                cacheDeck[code] = Deck2(current, d)
                app.deckTable.save(code, current, d)
            }
            callback(d)
        } else {
            callback(deck.text)
        }
    }

}