package com.rarnu.yugioh

object NativeAPI {
    init {
        System.loadLibrary("yugiohapi")
    }

    external fun parse(ahtml: String?, atype: Int): String

}
