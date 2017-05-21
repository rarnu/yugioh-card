package com.yugioh.android.fragments

import com.yugioh.android.R
import com.yugioh.android.utils.ResourceUtils

class LimitDetailFragment1 : LimitDetailFragment() {
    init {
        tabTitle = ResourceUtils.getString(R.string.card_limit1_pure)
        detailType = 1
    }
}
