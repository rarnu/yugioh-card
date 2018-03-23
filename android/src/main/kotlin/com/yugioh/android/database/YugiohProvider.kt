package com.yugioh.android.database

import android.content.ContentProvider
import android.content.ContentUris
import android.content.ContentValues
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import com.yugioh.android.common.Actions

class YugiohProvider : ContentProvider() {

    private var database: YugiohDatabase? = null

    override fun onCreate(): Boolean = true

    override fun delete(uri: Uri?, selection: String?, selectionArgs: Array<String>?): Int = 0

    override fun getType(uri: Uri?): String? = null

    override fun insert(uri: Uri?, values: ContentValues?): Uri? = null

    override fun query(uri: Uri?, projection: Array<String>?, selection: String?, selectionArgs: Array<String>?, sortOrder: String?): Cursor? {
        var actionId = -99
        try {
            actionId = ContentUris.parseId(uri).toInt()
        } catch (e: Exception) {

        }
        var c: Cursor? = null

        when (actionId) {
            YugiohProvider.ACTIONID_CLOSEDATABASE -> {
                database?.close()
                database = null
            }
            YugiohProvider.ACTIONID_NEWDATABASE ->
                if (database == null) {
                    try {
                        database = YugiohDatabase(context)
                        context.sendBroadcast(Intent(Actions.ACTION_EXTRACT_DATABASE_COMPLETE))
                    } catch (e: Exception) {

                    }
                }
            YugiohProvider.ACTIONID_VERSION -> c = database?.doGetVersion()
            else -> c = database?.doQuery(uri, projection, selection, selectionArgs, sortOrder)
        }
        return c
    }

    override fun update(uri: Uri?, values: ContentValues?, selection: String?, selectionArgs: Array<String>?): Int = 0

    companion object {

        val CONTENT_URI = Uri.parse("content://com.yugioh.card")!!
        const val ACTIONID_CLOSEDATABASE = -99
        const val ACTIONID_NEWDATABASE = -98
        const val ACTIONID_CARDCOUNT = -4
        const val ACTIONID_TOP100 = -2
        const val ACTIONID_SEARCH = -1
        const val ACTIONID_VERSION = -5
    }

}
