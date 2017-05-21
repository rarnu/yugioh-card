package com.yugioh.android.fragments

import com.yugioh.android.R
import com.yugioh.android.utils.ResourceUtils

class LimitDetailFragment2 : LimitDetailFragment() {
    init {
        tabTitle = ResourceUtils.getString(R.string.card_limit2_pure)
        detailType = 2
    }
}
