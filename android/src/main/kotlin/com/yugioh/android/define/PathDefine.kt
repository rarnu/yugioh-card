package com.yugioh.android.define

import android.os.Environment

import java.io.File

object PathDefine {

    val ROOT_PATH = Environment.getExternalStorageDirectory().absolutePath + "/.yugioh/"
    val APK_NAME = "YuGiOhCard.apk"
    val DATA_ZIP = "yugioh.zip"
    val DATA_NAME = "yugioh.db"
    val FAV_NAME = "fav.db"
    val DATABASE_PATH = ROOT_PATH + DATA_NAME
    val FAV_DATABASE_NAME = ROOT_PATH + FAV_NAME
    val PICTURE_PATH = ROOT_PATH + "images/"
    val DOWNLOAD_PATH = ROOT_PATH + "downloads/"
    val RECOMMAND_PATH = ROOT_PATH + "recommand/"
    val PACK_PATH = ROOT_PATH + "pack/"
    val DECK_PATH = ROOT_PATH + "deck/"
    val PACK_LIST = PACK_PATH + "list"
    val PACK_ITEM = PACK_PATH + "pack_%s"
    val DECK_LIST = DECK_PATH + "list"
    val DECK_ITEM = DECK_PATH + "deck_%s"

    fun init() {
        mkdir(ROOT_PATH)
        mkdir(PICTURE_PATH)
        mkdir(DOWNLOAD_PATH)
        mkdir(RECOMMAND_PATH)
        mkdir(PACK_PATH)
        mkdir(DECK_PATH)
    }

    private fun mkdir(path: String) {
        val fPath = File(path)
        if (!fPath.exists()) {
            fPath.mkdirs()
        }
    }

}
