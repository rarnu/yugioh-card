package com.rarnu.yugioh

import com.rarnu.common.blockingHttpGet

object YGORequest {

    const val BASE_URL = "https://www.ourocg.cn"
    const val RES_URL = "http://ocg.resource.m2v.cn/%d.jpg"

    private fun request(aurl: String) = blockingHttpGet(aurl)

    fun search(akey: String, apage: Int) = request("$BASE_URL/search/$akey/$apage")

    fun cardDetail(hashid: String) = request("$BASE_URL/card/$hashid")

    fun cardWiki(hashid: String) = request("$BASE_URL/card/$hashid/wiki")

    fun limit() = request("$BASE_URL/Limit-Latest")

    fun packageList() = request("$BASE_URL/package")

    fun packageDetail(aurl: String) = request("$BASE_URL$aurl")

    fun hotest() = request(BASE_URL)
}