package com.yugioh.android.base

import android.view.View
import android.view.ViewGroup

/**
 * Created by rarnu on 3/23/16.
 */
interface ISliding {

    fun setBehindContentView(v: View?, params: ViewGroup.LayoutParams?)

    fun setBehindContentView(v: View?)

    fun setBehindContentView(id: Int)

    fun getSlidingMenu(): SlidingMenu?

    fun toggle()

    fun showContent()

    fun showMenu()

    fun showSecondaryMenu()

    fun setSlidingActionBarEnabled(slidingActionBarEnabled: Boolean)
}