package com.yugioh.android.fragments

import com.rarnu.base.utils.ResourceUtils
import com.yugioh.android.R

class LimitDetailFragment2 : LimitDetailFragment() {
    init {
        tabTitle = ResourceUtils.getString(R.string.card_limit2_pure)
        detailType = 2
    }
}
