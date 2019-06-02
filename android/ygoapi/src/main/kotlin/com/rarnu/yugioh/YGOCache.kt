package com.rarnu.yugioh

import android.os.Environment
import com.rarnu.common.asFileReadText
import com.rarnu.common.asFileWriteText
import java.io.File

object YGOCache {

    private fun getCachePath(): String {
        val path = File(Environment.getExternalStoragePublicDirectory(""), "yugioh/cache")
        if (!path.exists()) {
            path.mkdirs()
        }
        var p = path.absolutePath
        if (!p.endsWith("/")) p += "/"
        return p
    }

    fun loadCache(hashid: String, type: Int): String? {
        val path = "${getCachePath()}${hashid}_$type.data"
        return if (File(path).exists()) {
            path.asFileReadText()
        } else {
            null
        }
    }

    fun saveCache(hashid: String, type: Int, text: String?) {
        val path = "${getCachePath()}${hashid}_$type.data"
        if (text != null) {
            path.asFileWriteText(text)
        }
    }

    fun cleanCache() = File(getCachePath()).deleteRecursively()

}