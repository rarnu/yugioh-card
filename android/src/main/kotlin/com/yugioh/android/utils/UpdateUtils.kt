package com.yugioh.android.utils

import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Message
import android.util.Log
import com.rarnu.base.utils.ConfigUtils
import com.rarnu.base.utils.FileUtils
import com.yugioh.android.classes.UpdateInfo
import com.yugioh.android.common.Actions
import com.yugioh.android.database.YugiohUtils
import com.yugioh.android.define.PathDefine
import kotlin.concurrent.thread

object UpdateUtils {

    fun checkUpdateT(context: Context, callback: (UpdateInfo?) -> Unit) = thread {
        val dbVer = YugiohUtils.getDatabaseVersion(context)
        val lastCardId = YugiohUtils.getLastCardId(context)
        val ui = YGOAPI.findUpdate(context, dbVer, lastCardId)
        callback(ui)
    }


    fun updateLocalDatabase(context: Context) {
        thread {
            val dbVer = YugiohUtils.getDatabaseVersion(context)
            val innerVer = ConfigUtils.getManifestIntConfig(context, "database-version", 0)!!
            Log.e("updateLocalDatabase", "database: $dbVer, apk: $innerVer")
            if (dbVer != -1 && innerVer > dbVer) {
                YugiohUtils.closeDatabase(context)
                FileUtils.deleteFile(PathDefine.DATABASE_PATH)
                FileUtils.copyAssetFile(context, "yugioh.db", PathDefine.ROOT_PATH, null)
                YugiohUtils.newDatabase(context)
                context.sendBroadcast(Intent(Actions.ACTION_EXTRACT_DATABASE_COMPLETE))
            }
        }
    }
}
