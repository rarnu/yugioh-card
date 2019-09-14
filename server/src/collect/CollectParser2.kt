package com.rarnu.ygo.server.collect

import com.rarnu.common.toJsonEncoded
import java.text.SimpleDateFormat
import java.util.*

fun List<Collect2>.toJSon(): String {
    var str = "["
    forEach {
        str += "{\"type\":${it.type},\"name\":\"${it.collectname}\",\"cardhash\":\"${it.cardhash}\",\"deckdata\":\"${it.deckdata.toJsonEncoded()}\",\"time\":\"${SimpleDateFormat("yyyy-MM-dd").format(Date(it.timeinfo))}\"},"
    }
    str = str.trimEnd(',')
    str += "]"
    return str
}