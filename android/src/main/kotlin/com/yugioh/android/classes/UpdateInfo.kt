package com.yugioh.android.classes

import java.io.Serializable

class UpdateInfo : Serializable {

    /**
     * -1: downloaded
     * 0:no update
     * 1:has update
     */
    var updateApk = 0
    var updateData=  0
    var newCard = 0
    var apkVersion = ""

}
