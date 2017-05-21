package com.yugioh.android.database

import android.content.ContentProvider
import android.content.ContentUris
import android.content.ContentValues
import android.database.Cursor
import android.net.Uri

class FavProvider : ContentProvider() {

    internal var database: FavDatabase? = null

    override fun delete(uri: Uri?, selection: String?, selectionArgs: Array<String>?): Int {
        database?.removeFav(ContentUris.parseId(uri).toInt())
        return 0
    }

    override fun getType(uri: Uri?): String? = null


    override fun insert(uri: Uri?, values: ContentValues?): Uri? {
        database?.addFav(ContentUris.parseId(uri).toInt())
        return null
    }

    override fun onCreate(): Boolean = true

    override fun query(uri: Uri?, projection: Array<String>?, selection: String?, selectionArgs: Array<String>?, sortOrder: String?): Cursor? {
        var actionId = -99
        try {
            actionId = ContentUris.parseId(uri).toInt()
        } catch (e: Exception) {

        }
        var c: Cursor? = null
        when (actionId) {
            ACTION_QUERY -> c = database?.queryFav(Integer.parseInt(selection))
            ACTION_QUERY_ALL -> c = database?.queryAllFav()
            ACTION_NEW -> if (database == null) {
                try {
                    database = FavDatabase(context)
                } catch (e: Exception) {
                }
            }
        }
        return c
    }

    override fun update(uri: Uri?, values: ContentValues?, selection: String?, selectionArgs: Array<String>?): Int = 0

    companion object {
        val CONTENT_URI = Uri.parse("content://com.yugioh.fav")!!
        val ACTION_QUERY = 1
        val ACTION_QUERY_ALL = 2
        val ACTION_NEW = 3;
    }
}
