package com.rarnu.ygo.server.deck

import com.rarnu.ygo.server.card.cacheMap
import java.io.File

object DeckUtil {
    fun isDeck(file: File) = file.readLines().all { it.startsWith("#") || it.startsWith("[") }
    fun getDeckName(file: File) = (file.readLines().firstOrNull { it.startsWith("#") } ?: "No Name").replace("#", "").trim()


    suspend fun loadMyDeck(file: File, callback:suspend (String) -> Unit) {

        fun itemToCardItem(str: String): String {
            val tmp = str.trim().trim('[', ']')
            val name: String
            var hash = ""
            var imgid = "0"
            if (tmp.contains(">>")) {
                val arr = tmp.split(">>")
                name = arr[0]
                hash = arr[1]
            } else {
                name = tmp
            }
            val m = cacheMap.filterValues { it.nwname == name }
            if (m.isNotEmpty()) {
                if (hash == "") {
                    hash = m.keys.elementAt(0)
                }
                if (imgid == "0") {
                    imgid = m.values.elementAt(0).imgid
                }
            }
            return "{\"name\":\"$name\",\"hash\":\"$hash\",\"imgid\":\"$imgid\"}"
        }

        val MAIN = "#MAIN"
        val EXTRA = "#EXTRA"
        val SIDE = "#SIDE"
        val list = file.readLines()

        val listMain = mutableListOf<String>()
        val listExtra = mutableListOf<String>()
        val listSide = mutableListOf<String>()
        val name = (list.firstOrNull { it.startsWith("#") && !it.startsWith(MAIN) && !it.startsWith(EXTRA) && !it.startsWith(SIDE) } ?: "").replace("#", "")
        var currentSection = 0
        list.forEach {
            when {
                it.trim() == MAIN -> currentSection = 0
                it.trim() == EXTRA -> currentSection = 1
                it.trim() == SIDE -> currentSection = 2
            }
            if (it.startsWith("[")) {
                when(currentSection) {
                    0 -> listMain.add(itemToCardItem(it))
                    1 -> listExtra.add(itemToCardItem(it))
                    2 -> listSide.add(itemToCardItem(it))
                }
            }
        }

        callback("{\"result\":0,\"name\":\"$name\",\"main\":[${listMain.joinToString(",")}],\"extra\":[${listExtra.joinToString(",")}],\"side\":[${listSide
            .joinToString(",")}]}")

    }
}