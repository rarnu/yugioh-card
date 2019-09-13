package com.rarnu.ygo.server.collect

data class Collect2(
    var id: Long,
    var userid: Long,
    var type: Int,
    var collectname: String,
    var cardhash: String,
    var deckdata: String,
    var timeinfo: Long
)