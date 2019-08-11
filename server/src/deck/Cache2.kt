package com.rarnu.ygo.server.deck

data class DeckTheme2(
    var timeinfo: Long,
    var text: String
)

data class DeckCategory2(
    var timeinfo: Long,
    var text: String
)

data class DeckInCategory2(
    var timeinfo: Long,
    var text: String
)

data class Deck2(
    var timeinfo: Long,
    var text: String
)

val cacheDeckTheme = DeckTheme2(0, "")
val cacheDeckCategory = DeckCategory2(0, "")
val cacheDeckInCategory = mutableMapOf<String, DeckInCategory2>()
val cacheDeck = mutableMapOf<String, Deck2>()