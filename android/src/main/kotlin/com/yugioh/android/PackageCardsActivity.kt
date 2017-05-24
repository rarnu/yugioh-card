package com.yugioh.android

import android.app.Fragment
import com.rarnu.base.app.BaseActivity
import com.yugioh.android.fragments.PackageCardsFragment

class PackageCardsActivity : BaseActivity() {

    override fun getActionBarCanBack(): Boolean = true

    override fun getIcon(): Int = R.drawable.icon

    override fun replaceFragment(): Fragment {
        val pcf = PackageCardsFragment()
        pcf.arguments = intent.extras
        return pcf
    }

    override fun customTheme(): Int = 0

}
