package com.yugioh.android

import android.app.Fragment
import com.yugioh.android.base.BaseActivity
import com.yugioh.android.fragments.DeckCardFragment

class DeckCardActivity : BaseActivity() {

    override fun getActionBarCanBack(): Boolean = true

    override fun getIcon(): Int = R.drawable.icon

    override fun replaceFragment(): Fragment {
        val dcf = DeckCardFragment()
        dcf.arguments = intent.extras
        return dcf
    }

    override fun customTheme(): Int = 0

}
