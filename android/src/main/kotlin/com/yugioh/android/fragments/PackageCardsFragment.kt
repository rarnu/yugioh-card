package com.yugioh.android.fragments

import android.content.Loader
import android.database.Cursor
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.*
import com.yugioh.android.R
import com.yugioh.android.base.BaseFragment
import com.yugioh.android.classes.CardItems
import com.yugioh.android.common.MenuIds
import com.yugioh.android.loader.SearchLoader
import com.yugioh.android.utils.MiscUtils
import com.yugioh.android.utils.ResourceUtils

class PackageCardsFragment : BaseFragment(), Loader.OnLoadCompleteListener<Cursor>, AdapterView.OnItemClickListener {

    internal var lvCards: ListView? = null
    internal var tvListNoCard: TextView? = null
    internal var tvLoading: TextView? = null
    internal var loader: SearchLoader? = null
    internal var cSearchResult: Cursor? = null
    internal var adapterSearchResult: SimpleCursorAdapter? = null
    internal var itemRefresh: MenuItem? = null

    private val hPack = object : Handler() {
        override fun handleMessage(msg: Message) {
            if (msg.what == 1) {
                tvLoading?.visibility = View.GONE
                itemRefresh?.isEnabled = true
                lvCards?.isEnabled = true
                val items = msg.obj as CardItems?
                val bn = Bundle()
                bn.putIntArray("ids", items?.cardIds)
                loader?.setBundle(bn)
                loader?.startLoading()
            }
            super.handleMessage(msg)
        }
    }

    init {
        tabTitle = ResourceUtils.getString(R.string.package_cards)
    }

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun getCustomTitle(): String? = arguments.getString("pack")

    override fun initComponents() {
        lvCards = innerView?.findViewById(R.id.lvCards) as ListView?
        tvListNoCard = innerView?.findViewById(R.id.tvListNoCard) as TextView?
        loader = SearchLoader(activity, arguments)
        tvLoading = innerView?.findViewById(R.id.tvLoading) as TextView?
    }

    override fun initEvents() {
        loader?.registerListener(0, this)
        lvCards?.onItemClickListener = this
    }

    override fun initLogic() {
        tvListNoCard?.setText(R.string.list_nocard_searching)
        loader?.startLoading()
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_package_cards

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
                itemRefresh?.isEnabled = false
                lvCards?.isEnabled = false
                MiscUtils.loadCardsDataT(0, arguments.getString("id"), hPack, true)
            }
        }
        return true
    }

    override fun onGetNewArguments(bn: Bundle?) {}

    override fun getFragmentState(): Bundle? = null

    override fun onLoadComplete(loader: Loader<Cursor>?, data: Cursor?) {
        if (data != null) {
            cSearchResult = data
            adapterSearchResult = SimpleCursorAdapter(activity, R.layout.item_card, cSearchResult, arrayOf("name", "sCardType"), intArrayOf(R.id.tvCardName, R.id.tvCardType), CursorAdapter.FLAG_REGISTER_CONTENT_OBSERVER)

        }
        if (activity != null) {
            lvCards?.adapter = adapterSearchResult
            tvListNoCard?.visibility = if (adapterSearchResult!!.count == 0) View.VISIBLE else View.GONE
            tvListNoCard?.setText(R.string.package_nocard)
        }
    }

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        MiscUtils.openCardDetail(activity, cSearchResult, position)
    }
}
