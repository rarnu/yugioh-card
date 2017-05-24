package com.yugioh.android.fragments

import android.app.Fragment
import android.os.Bundle
import android.view.Menu
import com.yugioh.android.R
import com.rarnu.base.app.BaseTabFragment

class LimitFragment : BaseTabFragment() {

    override fun initFragmentList(listFragment: MutableList<Fragment?>?) {
        listFragment?.add(LimitDetailFragment0())
        listFragment?.add(LimitDetailFragment1())
        listFragment?.add(LimitDetailFragment2())
    }

    override fun getBarTitle(): Int = R.string.lm_banned

    override fun getBarTitleWithPath(): Int = R.string.lm_banned

    override fun getCustomTitle(): String? = null

    override fun getMainActivityName(): String? = ""

    override fun initMenu(menu: Menu?) { }

    override fun onGetNewArguments(bn: Bundle?) { }

    override fun getFragmentState(): Bundle? = null


}
