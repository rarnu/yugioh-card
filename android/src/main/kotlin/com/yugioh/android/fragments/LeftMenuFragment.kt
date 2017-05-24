package com.yugioh.android.fragments

import android.os.Bundle
import android.view.Menu
import android.view.View
import android.widget.AdapterView
import android.widget.AdapterView.OnItemClickListener
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.RelativeLayout
import com.rarnu.base.app.BaseFragment
import com.rarnu.base.utils.UIUtils
import com.yugioh.android.MainActivity
import com.yugioh.android.R
import com.yugioh.android.intf.IMainIntf

class LeftMenuFragment : BaseFragment(), OnItemClickListener {

    internal var lvCard: ListView? = null
    internal var adapterCard: ArrayAdapter<String>? = null
    internal var listCard: MutableList<String>? = null

    override fun getBarTitle(): Int = R.string.app_name

    override fun getBarTitleWithPath(): Int = R.string.app_name


    override fun initComponents() {
        lvCard = innerView?.findViewById(R.id.lvCard) as ListView?
        listCard = arrayListOf()
        listCard?.add(getString(R.string.lm_search))        // 0
        listCard?.add(getString(R.string.lm_banned))        // 1
        listCard?.add(getString(R.string.lm_newcard))       // 2
        listCard?.add(getString(R.string.lm_package))       // 3
        listCard?.add(getString(R.string.lm_myfav))         // 4
        listCard?.add(getString(R.string.lm_tool))          // 5
        adapterCard = ArrayAdapter(activity, R.layout.item_menu, listCard)
        lvCard?.adapter = adapterCard

        val lvHeight = UIUtils.dip2px((48 + UIUtils.density!! * 2).toInt() * 6)
        val marginTop = (UIUtils.height!! - UIUtils.statusBarHeight!! - lvHeight) / 2
        val rllp = lvCard?.layoutParams as RelativeLayout.LayoutParams?
        rllp?.topMargin = marginTop
        rllp?.height = lvHeight
        lvCard?.layoutParams = rllp
    }

    override fun initEvents() {
        lvCard?.onItemClickListener = this
    }

    override fun initLogic() {

    }

    override fun getFragmentLayoutResId(): Int = R.layout.menu_left

    override fun getMainActivityName(): String? = MainActivity::class.java.name

    override fun initMenu(menu: Menu?) {

    }

    override fun onGetNewArguments(bn: Bundle?) {

    }

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        when (parent?.id) {
            R.id.lvCard -> (activity as IMainIntf).switchPage(position, true)
        }
    }

    override fun getCustomTitle(): String? = null

    override fun getFragmentState(): Bundle? = null
}
