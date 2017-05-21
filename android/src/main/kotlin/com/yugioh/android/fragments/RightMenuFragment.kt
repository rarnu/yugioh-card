package com.yugioh.android.fragments

import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.View
import android.widget.AdapterView
import android.widget.AdapterView.OnItemClickListener
import android.widget.ListView
import android.widget.RelativeLayout
import com.yugioh.android.*
import com.yugioh.android.adapter.RightMenuAdapter
import com.yugioh.android.base.BaseFragment
import com.yugioh.android.classes.RightMenuItem
import com.yugioh.android.classes.UpdateInfo
import com.yugioh.android.utils.UIUtils

import java.util.ArrayList

class RightMenuFragment : BaseFragment(), OnItemClickListener {

    internal var lvSettings: ListView? = null
    internal var listSettings: MutableList<RightMenuItem>? = null
    internal var adapterSettings: RightMenuAdapter? = null
    internal var updateInfo: UpdateInfo? = null

    override fun getBarTitle(): Int = R.string.app_name

    override fun getBarTitleWithPath(): Int = R.string.app_name

    override fun initComponents() {
        lvSettings = innerView?.findViewById(R.id.lvSettings) as ListView?
        listSettings = arrayListOf()
        val itemSettings = RightMenuItem(getString(R.string.rm_settings))
        val itemUpdate = RightMenuItem(getString(R.string.rm_update))
        val itemFeedback = RightMenuItem(getString(R.string.rm_feedback))
        val itemAbout = RightMenuItem(getString(R.string.rm_about))
        listSettings?.add(itemSettings)
        listSettings?.add(itemUpdate)
        listSettings?.add(itemFeedback)
        listSettings?.add(itemAbout)
        adapterSettings = RightMenuAdapter(activity, listSettings)
        lvSettings?.adapter = adapterSettings
        val lvHeight = UIUtils.dip2px((48 + UIUtils.density!! * 2).toInt() * 4)
        val marginTop = (UIUtils.height!! - UIUtils.statusBarHeight!! - lvHeight) / 2
        val rllp = lvSettings?.layoutParams as RelativeLayout.LayoutParams?
        rllp?.topMargin = marginTop
        rllp?.height = lvHeight
        lvSettings?.layoutParams = rllp
    }

    override fun initEvents() {
        lvSettings?.onItemClickListener = this
    }

    override fun initLogic() {

    }

    override fun getFragmentLayoutResId(): Int = R.layout.menu_right

    override fun getMainActivityName(): String? = MainActivity::class.java.name

    override fun initMenu(menu: Menu?) {}

    override fun onGetNewArguments(bn: Bundle?) {}

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        when (parent?.id) {
            R.id.lvSettings -> when (position) {
                0 -> startActivity(Intent(activity, SettingsActivity::class.java))
                1 -> startActivity(Intent(activity, UpdateActivity::class.java))
                2 -> startActivity(Intent(activity, FeedbackActivity::class.java))
                3 -> startActivity(Intent(activity, AboutActivity::class.java))
            }
        }
    }

    override fun getCustomTitle(): String? = null

    override fun getFragmentState(): Bundle? = null

}
