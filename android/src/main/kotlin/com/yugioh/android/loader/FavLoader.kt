package com.yugioh.android.loader

import android.content.Context
import android.database.Cursor
import com.rarnu.base.app.BaseClassLoader
import com.yugioh.android.database.FavUtils
import com.yugioh.android.database.YugiohUtils

class FavLoader(context: Context) : BaseClassLoader<Cursor>(context) {

    override fun loadInBackground(): Cursor? {
        var cResult: Cursor? = null
        val c = FavUtils.queryAllFav(context)
        if (c != null) {
            val ids = IntArray(c.count)
            c.moveToFirst()
            var idx = 0
            while (!c.isAfterLast) {
                ids[idx] = c.getInt(c.getColumnIndex("cardId"))
                idx++
                c.moveToNext()
            }
            c.close()
            if (ids.isNotEmpty()) {
                cResult = YugiohUtils.getCardsViaIds(context, ids)
            }
        }
        return cResult
    }
}
