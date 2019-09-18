package com.rarnu.ygo.server.deck

import java.io.File

object DeckUtil {
    fun isDeck(file: File) = file.readLines().all { it.startsWith("#") || it.startsWith("[") }
    fun getDeckName(file: File) = (file.readLines().firstOrNull { it.startsWith("#") } ?: "No Name").replace("#", "").trim()


    suspend fun loadMyDeck(file: File, callback:suspend (String) -> Unit) {
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
                    0 -> listMain.add(it.trim('[', ']'))
                    1 -> listExtra.add(it.trim('[', ']'))
                    2 -> listSide.add(it.trim('[', ']'))
                }
            }
        }

        callback("{\"result\":0,\"name\":\"$name\",\"main\":[${listMain.joinToString(",") { "\"$it\"" }}],\"extra\":[${listExtra.joinToString(",") { "\"$it\"" }}],\"side\":[${listSide
            .joinToString(",") { "\"$it\"" }}]}")
    }
}