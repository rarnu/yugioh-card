package com.yugioh.android

import android.app.Fragment

import com.rarnu.base.app.BaseActivity
import com.yugioh.android.fragments.SettingsFragment

class SettingsActivity : BaseActivity() {

    override fun getActionBarCanBack(): Boolean = true

    override fun getIcon(): Int = R.drawable.icon

    override fun replaceFragment(): Fragment = SettingsFragment()

    override fun customTheme(): Int = 0

}
