package com.rarnu.yugioh

object NativeAPI {
    init {
        System.loadLibrary("yugiohapi")
    }

    external fun cardSearch(
            aname: String,
            ajapname: String,
            aenname: String,
            arace: String,
            aelement: String,
            aatk: String,
            adef: String,
            alevel: String,
            apendulum: String,
            alink: String,
            alinkarrow: String,
            acardtype: String,
            acardtype2: String,
            aeffect: String,
            apage: Int): String


}
