package com.yugioh.android.database

import android.content.ContentUris
import android.content.Context
import android.database.Cursor

object FavUtils {

    fun newFavDatabase(context: Context) = context.contentResolver.query(ContentUris.withAppendedId(FavProvider.CONTENT_URI, FavProvider.ACTION_NEW.toLong()), null, null, null, null)!!

    fun addFav(context: Context, id: Int) = context.contentResolver.insert(ContentUris.withAppendedId(FavProvider.CONTENT_URI, id.toLong()), null)!!

    fun removeFav(context: Context, id: Int) = context.contentResolver.delete(ContentUris.withAppendedId(FavProvider.CONTENT_URI, id.toLong()), null, null)

    fun queryFav(context: Context, id: Int): Boolean {
        var ret = false
        val c = context.contentResolver.query(ContentUris.withAppendedId(FavProvider.CONTENT_URI, FavProvider.ACTION_QUERY.toLong()), null, id.toString(), null, null)
        if (c != null) {
            c.moveToFirst()
            while (!c.isAfterLast) {
                ret = true
                c.moveToNext()
            }
            c.close()
        }
        return ret
    }

    fun queryAllFav(context: Context): Cursor? =
            context.contentResolver.query(ContentUris.withAppendedId(FavProvider.CONTENT_URI, FavProvider.ACTION_QUERY_ALL.toLong()), null, null, null, null)

}
