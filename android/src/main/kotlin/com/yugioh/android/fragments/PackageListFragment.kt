package com.yugioh.android.fragments

import android.content.Intent
import android.content.Loader
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.AdapterView
import android.widget.Toast
import com.rarnu.base.app.BaseFragment
import com.rarnu.base.utils.ResourceUtils
import com.yugioh.android.PackageCardsActivity
import com.yugioh.android.R
import com.yugioh.android.adapter.PackageAdapter
import com.yugioh.android.classes.PackageItem
import com.yugioh.android.common.MenuIds
import com.yugioh.android.loader.PackageLoader
import com.yugioh.android.utils.MiscUtils
import kotlinx.android.synthetic.main.fragment_package_list.view.*

class PackageListFragment : BaseFragment(), AdapterView.OnItemClickListener, Loader.OnLoadCompleteListener<MutableList<PackageItem>?> {

    internal var loader: PackageLoader? = null
    internal var adapter: PackageAdapter? = null
    internal var list: MutableList<PackageItem>? = null
    private var itemRefresh: MenuItem? = null

    init {
        tabTitle = ResourceUtils.getString(R.string.package_list)
    }

    override fun getBarTitle(): Int = R.string.lm_package

    override fun getBarTitleWithPath(): Int = R.string.lm_package

    override fun getCustomTitle(): String? = null

    override fun initComponents() {
        loader = PackageLoader(activity)
        list = arrayListOf()
        adapter = PackageAdapter(activity, list)
        innerView.lvPackage.adapter = adapter
    }

    override fun initEvents() {
        innerView.lvPackage.onItemClickListener = this
        loader?.registerListener(0, this)
    }

    override fun initLogic() {
        innerView.tvListNoPackage.setText(R.string.package_nocard_search)
        innerView.tvLoading.visibility = View.VISIBLE
        loader?.startLoading()
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_package_list

    override fun getMainActivityName(): String? = ""

    override fun initMenu(menu: Menu) {
        itemRefresh = menu.add(0, MenuIds.MENUID_REFRESH, 99, R.string.refresh)
        itemRefresh?.setIcon(android.R.drawable.ic_menu_revert)
        itemRefresh?.setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            MenuIds.MENUID_REFRESH -> {
                innerView.tvLoading.visibility = View.VISIBLE
                loader?.refresh = true
                loader?.startLoading()
            }
        }
        return true
    }

    override fun onGetNewArguments(bn: Bundle?) {}

    override fun getFragmentState(): Bundle? = null

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        innerView.tvLoading.visibility = View.VISIBLE
        innerView.lvPackage.isEnabled = false
        val item = list!![position]
        MiscUtils.loadCardsDataT(0, item.id, false) {
            activity.runOnUiThread {
                innerView.lvPackage.isEnabled = true
                innerView.tvLoading.visibility = View.GONE
                val bn = Bundle()
                if (it != null) {
                    bn.putIntArray("ids", it.cardIds)
                    bn.putString("pack", it.packageName)
                    bn.putString("id", it.id)
                    val inCards = Intent(activity, PackageCardsActivity::class.java)
                    inCards.putExtras(bn)
                    startActivity(inCards)
                } else {
                    Toast.makeText(activity, R.string.package_cannot_load, Toast.LENGTH_LONG).show()
                }
            }
        }
    }

    override fun onLoadComplete(loader: Loader<MutableList<PackageItem>?>?, data: MutableList<PackageItem>?) {
        list?.clear()
        if (data != null) {
            list?.addAll(data)
        }
        if (activity != null) {
            adapter?.setNewList(list)
            innerView.tvLoading.visibility = View.GONE
            innerView.tvListNoPackage.visibility = if (list!!.size == 0) View.VISIBLE else View.GONE
            innerView.tvListNoPackage.setText(R.string.package_list_not_exist)
        }
    }
}
