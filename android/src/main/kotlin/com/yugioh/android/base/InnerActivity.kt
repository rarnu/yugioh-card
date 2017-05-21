package com.yugioh.android.base

import android.app.ActionBar
import android.app.Activity
import android.app.Fragment
import android.os.Bundle
import android.view.MenuItem
import android.view.ViewTreeObserver
import android.view.Window
import android.widget.RelativeLayout
import com.yugioh.android.R
import com.yugioh.android.utils.DrawableUtils
import com.yugioh.android.utils.UIUtils

/**
 * Created by rarnu on 3/23/16.
 */
abstract class InnerActivity: Activity(), ViewTreeObserver.OnGlobalLayoutListener {

    protected var bar: ActionBar? = null
    protected var layoutReplacement: RelativeLayout? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        if (customTheme() != 0) {
            setTheme(customTheme())
        }
        requestWindowFeature(Window.FEATURE_ACTION_BAR)
        super.onCreate(savedInstanceState)
        if (getCloseCondition()) {
            finish()
            return
        }
        setContentView(getBaseLayout())

        layoutReplacement = findViewById(R.id.layoutReplacement) as RelativeLayout
        layoutReplacement?.viewTreeObserver?.addOnGlobalLayoutListener(this)
        layoutReplacement?.background =  if (UIUtils.isFollowSystemBackground) { DrawableUtils.getDetailsElementBackground(this) } else { null }

        actionBar?.setIcon(getIcon())
        if (getActionBarCanBack()) {
            actionBar?.setDisplayOptions(0, ActionBar.DISPLAY_HOME_AS_UP)
            actionBar?.setDisplayHomeAsUpEnabled(true)
        }
        replace()
    }

    abstract fun getIcon(): Int

    abstract fun getCloseCondition(): Boolean

    abstract fun getBaseLayout(): Int

    abstract fun getReplaceId(): Int

    abstract fun replaceFragment(): Fragment

    abstract fun customTheme(): Int

    abstract fun getActionBarCanBack(): Boolean

    open fun replace() = fragmentManager.beginTransaction().replace(getReplaceId(), replaceFragment()).commit()

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            android.R.id.home -> finish()
        }
        return super.onOptionsItemSelected(item)
    }

    override fun onGlobalLayout() = onLayoutReady()

    /**
     * override the method if you want to re-layout after system layouted
     */
    open fun onLayoutReady() { }
}