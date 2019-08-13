package com.rarnu.yugioh

import android.util.Log
import com.rarnu.common.http

object YGORequest {

    // const val BASE_URL = "http://119.3.22.119"
    const val BASE_URL = "http://122.112.175.64"
    const val RES_URL = "http://ocg.resource.m2v.cn/%d.jpg"

    private fun request(aurl: String, param: String = "") = try { http {
        url = aurl
        getParam = param
    } } catch (th: Throwable) {
        Log.e("YGO", "error => $th")
        null
    }

    fun search(akey: String, apage: Int) = request("$BASE_URL/search", "key=$akey&page=$apage")

    fun cardDetail(hashid: String) = request("$BASE_URL/carddetail", "hash=$hashid")

    fun limit() = request("$BASE_URL/limit")

    fun packageList() = request("$BASE_URL/packlist")

    fun packageDetail(aurl: String) = request("$BASE_URL/packdetail", "url=$aurl")

    fun hotest() = request("$BASE_URL/hotest")
}