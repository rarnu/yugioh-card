package com.yugioh.android

import android.app.Fragment
import android.os.Bundle
import com.rarnu.base.app.BaseDialog
import com.yugioh.android.fragments.LinkOptionFragment

class LinkOptionActivity : BaseDialog() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setFinishOnTouchOutside(false)
    }

    override fun getCloseCondition(): Boolean = false

    override fun replaceFragment(): Fragment = LinkOptionFragment()

    override fun customTheme(): Int = 0

}
