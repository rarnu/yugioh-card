package com.rarnu.yugioh.card

import android.os.Environment
import java.io.File

object PathUtils {

    val IMAGE_PATH = File(Environment.getExternalStoragePublicDirectory(""), "yugioh")

    init {
        if (!IMAGE_PATH.exists()) {
            IMAGE_PATH.mkdirs()
        }
    }

}