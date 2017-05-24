package com.yugioh.android.loader

import android.content.Context
import android.database.Cursor

import com.rarnu.base.app.BaseCursorLoader
import com.yugioh.android.database.YugiohUtils

class LimitLoader(context: Context, private val detailType: Int) : BaseCursorLoader(context) {

    override fun loadInBackground(): Cursor? {
        var cLimit: Cursor? = null
        when (detailType) {
            0 -> cLimit = YugiohUtils.getBannedCards(context)
            1 -> cLimit = YugiohUtils.getLimit1Cards(context)
            2 -> cLimit = YugiohUtils.getLimit2Cards(context)
        }
        return cLimit
    }
}
