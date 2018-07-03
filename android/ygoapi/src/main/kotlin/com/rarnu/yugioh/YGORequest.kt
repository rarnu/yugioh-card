package com.rarnu.yugioh

import com.rarnu.kt.android.HttpMethod
import com.rarnu.kt.android.http

object YGORequest {

    const val BASE_URL = "https://www.ourocg.cn"
    const val RES_URL = "http://ocg.resource.m2v.cn/%s.jpg"

    private fun request(aurl: String) = http {
        url = aurl
        method = HttpMethod.GET
    }

    fun search(akey: String, apage: Int) = request("$BASE_URL/search/$akey/$apage")

    fun cardDetail(hashid: String) = request("$BASE_URL/card/$hashid")

    fun cardWiki(hashid: String) = request("$BASE_URL/card/$hashid/wiki")

    fun limit() = request("$BASE_URL/Limit-Latest")

    fun packageList() = request("$BASE_URL/package")

    fun packageDetail(aurl: String) = request("$BASE_URL$aurl")

}