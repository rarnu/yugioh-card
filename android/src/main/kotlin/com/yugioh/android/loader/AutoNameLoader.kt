package com.yugioh.android.loader

import android.content.Context
import android.database.Cursor
import com.yugioh.android.base.BaseClassLoader
import com.yugioh.android.database.YugiohUtils

class AutoNameLoader(context: Context) : BaseClassLoader<Cursor>(context) {

    var name = ""

    override fun loadInBackground(): Cursor? {
        var c: Cursor? = null
        if (name != "") {
            c = YugiohUtils.getCardNames(context, name)
        }
        return c
    }
}
