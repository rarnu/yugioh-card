package com.rarnu.yugioh

import com.rarnu.common.blockingHttp
import com.rarnu.common.blockingHttpGet

object YGORequest {

    const val BASE_URL = "http://119.3.22.119"
    const val RES_URL = "http://ocg.resource.m2v.cn/%d.jpg"

    private fun request(aurl: String, param: String = "") = blockingHttp {
        url = aurl
        getParam = param
    }

    fun search(akey: String, apage: Int) = request("$BASE_URL/search", "key=$akey&page=$apage")

    fun cardDetail(hashid: String) = request("$BASE_URL/carddetail", "hash=$hashid")

    fun cardAdjust(hashid: String) = request("$BASE_URL/cardadjust", "hash=$hashid")

    fun cardWiki(hashid: String) = request("$BASE_URL/cardwiki", "hash=$hashid")

    fun limit() = request("$BASE_URL/limit")

    fun packageList() = request("$BASE_URL/packlist")

    fun packageDetail(aurl: String) = request("$BASE_URL/packdetail", "url=$aurl")

    fun hotest() = request("$BASE_URL/hotest")
}