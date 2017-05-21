package com.yugioh.android.loader

import android.content.Context
import android.database.Cursor

import com.yugioh.android.base.BaseCursorLoader
import com.yugioh.android.database.YugiohUtils

class NewCardLoader(context: Context) : BaseCursorLoader(context) {

    override fun loadInBackground(): Cursor? = YugiohUtils.getLatest100(context)

}
