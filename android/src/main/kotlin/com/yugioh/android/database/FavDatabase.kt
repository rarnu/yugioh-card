package com.yugioh.android.database

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import com.rarnu.base.app.common.Actions
import com.rarnu.base.utils.FileUtils
import com.yugioh.android.define.PathDefine
import java.io.File

class FavDatabase(ctx: Context) {

    private var context: Context? = ctx
    private var database: SQLiteDatabase? = null

    private fun asyncCopy(context: Context?) = FileUtils.copyAssetFile(context!!, "fav.db", PathDefine.ROOT_PATH) { status, _, _ ->
        if (status == Actions.WHAT_COPY_FINISH) {
            database = SQLiteDatabase.openDatabase(PathDefine.FAV_DATABASE_NAME, null, SQLiteDatabase.OPEN_READWRITE)
        }
    }

    fun addFav(id: Int) {
        val cv = ContentValues()
        cv.put("cardId", id)
        try {
            database?.insert(TABLE_FAV, null, cv)
        } catch (e: Exception) {

        }
    }

    fun removeFav(id: Int) {
        try {
            database?.delete(TABLE_FAV, String.format("cardId=%d", id), null)
        } catch (e: Exception) {

        }
    }

    fun queryFav(id: Int): Cursor? = database?.query(TABLE_FAV, null, String.format("cardId=%d", id), null, null, null, null)

    fun queryAllFav(): Cursor? = database?.query(TABLE_FAV, null, null, null, null, null, null)

    companion object {
        private const val TABLE_FAV = "fav"
        val isDatabaseFileExists: Boolean
            get() = File(PathDefine.FAV_DATABASE_NAME).exists()
    }

    init {
        val fDb = File(PathDefine.FAV_DATABASE_NAME)
        if (!fDb.exists()) {
            asyncCopy(context)
        }
        database = SQLiteDatabase.openDatabase(PathDefine.FAV_DATABASE_NAME, null, SQLiteDatabase.OPEN_READWRITE)
    }
}
