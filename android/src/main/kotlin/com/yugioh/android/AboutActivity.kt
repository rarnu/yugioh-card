package com.yugioh.android

import android.app.Fragment
import com.rarnu.base.app.BaseDialog

import com.yugioh.android.fragments.AboutFragment

class AboutActivity : BaseDialog() {

    override fun getCloseCondition(): Boolean = false

    override fun replaceFragment(): Fragment = AboutFragment()

    override fun customTheme(): Int = 0

}
