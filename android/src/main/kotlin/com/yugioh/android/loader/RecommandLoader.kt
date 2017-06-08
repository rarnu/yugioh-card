package com.yugioh.android.loader

import android.content.Context

import com.rarnu.base.app.BaseLoader
import com.yugioh.android.classes.RecommandInfo
import com.yugioh.android.utils.YGOAPI

class RecommandLoader(context: Context) : BaseLoader<RecommandInfo>(context) {

    override fun loadInBackground(): MutableList<RecommandInfo>? = YGOAPI.recommands

}