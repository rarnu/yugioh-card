package com.yugioh.android

import android.app.Fragment
import com.yugioh.android.base.BaseActivity
import com.yugioh.android.fragments.SearchResultFragment

/**
 * Created by rarnu on 7/16/15.
 */
class SearchResultActivity : BaseActivity() {

    override fun getActionBarCanBack(): Boolean = true

    override fun getIcon(): Int = R.drawable.icon

    override fun replaceFragment(): Fragment = SearchResultFragment()

    override fun customTheme(): Int = 0

}
