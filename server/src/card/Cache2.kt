package com.rarnu.ygo.server.card

data class CardCache2(
    var data: String,
    var adjust: String,
    var wiki: String,
    var timeinfo: Long,
    var nwname: String
)

data class CardLimit2(
    var timeinfo: Long,
    var text: String
)

data class CardPack2(
    var timeinfo: Long,
    var text: String
)

data class CardDetail2(
    var timeinfo: Long,
    var text: String
)

val cacheMap = mutableMapOf<String, CardCache2>()
val cacheLimit = CardLimit2(0, "")
val cachePack = CardPack2(0, "")
val cachePackDetail = mutableMapOf<String, CardDetail2>()

