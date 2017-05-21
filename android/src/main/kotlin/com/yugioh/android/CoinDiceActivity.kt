package com.yugioh.android

import android.app.Fragment

import com.yugioh.android.base.BaseActivity
import com.yugioh.android.fragments.CoinDiceFragment

class CoinDiceActivity : BaseActivity() {

    override fun getActionBarCanBack(): Boolean = true

    override fun getIcon(): Int = R.drawable.icon

    override fun replaceFragment(): Fragment = CoinDiceFragment()

    override fun customTheme(): Int = 0

}
