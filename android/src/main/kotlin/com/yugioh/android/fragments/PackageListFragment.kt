package com.yugioh.android.fragments

import android.content.Intent
import android.content.Loader
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.AdapterView
import android.widget.ListView
import android.widget.TextView
import android.widget.Toast
import com.yugioh.android.PackageCardsActivity
import com.yugioh.android.R
import com.yugioh.android.adapter.PackageAdapter
import com.yugioh.android.base.BaseFragment
import com.yugioh.android.classes.CardItems
import com.yugioh.android.classes.PackageItem
import com.yugioh.android.common.MenuIds
import com.yugioh.android.loader.PackageLoader
import com.yugioh.android.utils.MiscUtils
import com.yugioh.android.utils.ResourceUtils

import java.util.ArrayList


class PackageListFragment : BaseFragment(), AdapterView.OnItemClickListener, Loader.OnLoadCompleteListener<MutableList<PackageItem>?> {

    internal var lvPackage: ListView? = null
    internal var tvLoading: TextView? = null
    internal var loader: PackageLoader? = null
    internal var adapter: PackageAdapter? = null
    internal var tvListNoPackage: TextView? = null
    internal var list: MutableList<PackageItem>? = null
    internal var itemRefresh: MenuItem? = null

    private val hPack = object : Handler() {
        override fun handleMessage(msg: Message) {
            if (msg.what == 1) {
                lvPackage?.isEnabled = true
                tvLoading?.visibility = View.GONE
                val bn = Bundle()
                val items = msg.obj as CardItems?
                if (items != null) {
                    bn.putIntArray("ids", items.cardIds)
                    bn.putString("pack", items.packageName)
                    bn.putString("id", items.id)
                    val inCards = Intent(activity, PackageCardsActivity::class.java)
                    inCards.putExtras(bn)
                    startActivity(inCards)
                } else {
                    Toast.makeText(activity, R.string.package_cannot_load, Toast.LENGTH_LONG).show()
                }
            }
            super.handleMessage(msg)
        }
    }

    init {
        tabTitle = ResourceUtils.getString(R.string.package_list)
    }

    override fun getBarTitle(): Int = R.string.lm_package

    override fun getBarTitleWithPath(): Int = R.string.lm_package

    override fun getCustomTitle(): String? = null

    override fun initComponents() {
        lvPackage = innerView?.findViewById(R.id.lvPackage) as ListView?
        tvLoading = innerView?.findViewById(R.id.tvLoading) as TextView?
        tvListNoPackage = innerView?.findViewById(R.id.tvListNoPackage) as TextView?
        loader = PackageLoader(activity)
        list = arrayListOf()
        adapter = PackageAdapter(activity, list)
        lvPackage?.adapter = adapter
    }

    override fun initEvents() {
        lvPackage?.onItemClickListener = this
        loader?.registerListener(0, this)
    }

    override fun initLogic() {
        tvListNoPackage?.setText(R.string.package_nocard_search)
        tvLoading?.visibility = View.VISIBLE
        loader?.startLoading()
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_package_list

    override fun getMainActivityName(): String? = ""

    override fun initMenu(menu: Menu?) {
        itemRefresh = menu?.add(0, MenuIds.MENUID_REFRESH, 99, R.string.refresh)
        itemRefresh?.setIcon(android.R.drawable.ic_menu_revert)
        itemRefresh?.setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            MenuIds.MENUID_REFRESH -> {
                tvLoading?.visibility = View.VISIBLE
                loader?.refresh = true
                loader?.startLoading()
            }
        }
        return true
    }

    override fun onGetNewArguments(bn: Bundle?) {}

    override fun getFragmentState(): Bundle? = null

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        tvLoading?.visibility = View.VISIBLE
        lvPackage?.isEnabled = false
        val item = list!![position]
        MiscUtils.loadCardsDataT(0, item.id, hPack, false)
    }

    override fun onLoadComplete(loader: Loader<MutableList<PackageItem>?>?, data: MutableList<PackageItem>?) {
        list?.clear()
        if (data != null) {
            list?.addAll(data)
        }
        if (activity != null) {
            adapter?.setNewList(list)
            tvLoading?.visibility = View.GONE
            tvListNoPackage?.visibility = if (list!!.size == 0) View.VISIBLE else View.GONE
            tvListNoPackage?.setText(R.string.package_list_not_exist)
        }
    }
}
