package com.yugioh.android.loader

import android.content.Context
import com.rarnu.base.app.BaseClassLoader
import com.yugioh.android.utils.YGOAPI

class FeedbackSender(context: Context) : BaseClassLoader<Boolean>(context) {

    var text: String? = null

    override fun loadInBackground(): Boolean? = YGOAPI.sendFeedback(context, text)

}
