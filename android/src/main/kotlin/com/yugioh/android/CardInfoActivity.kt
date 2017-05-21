package com.yugioh.android

import android.app.Fragment

import com.yugioh.android.base.BaseActivity
import com.yugioh.android.fragments.CardInfoFragment

class CardInfoActivity : BaseActivity() {

    override fun getActionBarCanBack(): Boolean = true

    override fun getIcon(): Int = R.drawable.icon

    override fun replaceFragment(): Fragment = CardInfoFragment()

    override fun customTheme(): Int = 0

}
