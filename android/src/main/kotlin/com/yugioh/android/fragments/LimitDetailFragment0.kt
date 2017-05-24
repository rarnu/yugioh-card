package com.yugioh.android.fragments

import com.rarnu.base.utils.ResourceUtils
import com.yugioh.android.R

class LimitDetailFragment0 : LimitDetailFragment() {
    init {
        tabTitle = ResourceUtils.getString(R.string.card_banned_pure)
        detailType = 0
    }
}
