package com.yugioh.android.fragments

import com.rarnu.base.utils.ResourceUtils
import com.yugioh.android.R

class LimitDetailFragment1 : LimitDetailFragment() {
    init {
        tabTitle = ResourceUtils.getString(R.string.card_limit1_pure)
        detailType = 1
    }
}
