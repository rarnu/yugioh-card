package com.rarnu.yugioh

import android.os.Environment
import com.rarnu.kt.android.fileDelete
import com.rarnu.kt.android.fileReadText
import com.rarnu.kt.android.fileWriteText
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
            fileReadText(path)
        } else {
            null
        }
    }

    fun saveCache(hashid: String, type: Int, text: String?) {
        val path = "${getCachePath()}${hashid}_$type.data"
        if (text != null) {
            fileWriteText(path, text)
        }
    }

    fun cleanCache() = fileDelete {
        src = getCachePath()
    }

}