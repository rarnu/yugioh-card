package com.yugioh.android.database

import android.content.ContentUris
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.net.Uri
import com.rarnu.base.app.common.Actions
import com.rarnu.base.utils.FileUtils
import com.yugioh.android.define.PathDefine
import java.io.File

class YugiohDatabase(ctx: Context) {

    private var database: SQLiteDatabase? = null

    private fun asyncCopy(context: Context) {
        context.sendBroadcast(Intent(com.yugioh.android.common.Actions.ACTION_EXTRACT_DATABASE))
        FileUtils.copyAssetFile(context, "yugioh.db", PathDefine.ROOT_PATH) { status, _, _ ->
            if (status == Actions.WHAT_COPY_FINISH) {
                database = SQLiteDatabase.openDatabase(PathDefine.DATABASE_PATH, null, SQLiteDatabase.OPEN_READONLY)
                context.sendBroadcast(Intent(com.yugioh.android.common.Actions.ACTION_EXTRACT_DATABASE_COMPLETE))
            }
        }
    }

    fun doQuery(uri: Uri?, projection: Array<String>?, selection: String?, selectionArgs: Array<String>?, sortOrder: String?): Cursor? {
        var actionId = -99
        try {
            actionId = ContentUris.parseId(uri).toInt()
        } catch (e: Exception) {

        }
        var c: Cursor? = null
        if (database != null && database!!.isOpen) {
            when (actionId) {
                YugiohProvider.ACTIONID_CARDCOUNT -> c = database?.rawQuery("select _id from ygodata order by _id desc limit 0,1", null)
                YugiohProvider.ACTIONID_TOP100 -> c = database?.rawQuery("select _id, name, sCardType from ygodata order by _id desc limit 0,100 ", null)
                YugiohProvider.ACTIONID_SEARCH -> c = database?.query("ygodata", projection, selection, selectionArgs, null, null, sortOrder)
                else -> if (actionId >= 0) {
                    c = database?.rawQuery("select * from ygodata where _id=?", arrayOf(actionId.toString()))
                }
            }
        }
        return c
    }

    fun close() = database?.close()

    fun doGetVersion(): Cursor? {
        var c: Cursor? = null
        try {
            c = database?.rawQuery("select * from version", null)
        } catch (e: Exception) {

        }
        return c
    }

    companion object {

        val isDatabaseFileExists: Boolean
            get() = File(PathDefine.DATABASE_PATH).exists()
    }

    init {
        val fDb = File(PathDefine.DATABASE_PATH)
        if (!fDb.exists()) {
            asyncCopy(ctx)
        }
        database = SQLiteDatabase.openDatabase(PathDefine.DATABASE_PATH, null, SQLiteDatabase.OPEN_READONLY)
    }

}
