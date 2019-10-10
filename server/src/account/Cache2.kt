package com.rarnu.ygo.server.account

data class AccountCache2(
    var id: Long,
    var account: String,
    var password: String,
    var nickname: String,
    var headimg: String,
    var email: String,
    var wxid: String
)

data class ValidateCode2(
    var code: String,
    var time: Long
)

val cacheAccount = mutableMapOf<Long, AccountCache2>()
val cacheValidateCode = mutableMapOf<String, ValidateCode2>()