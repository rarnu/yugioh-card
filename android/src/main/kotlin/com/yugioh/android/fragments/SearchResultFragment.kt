package com.yugioh.android.fragments

import android.content.Loader
import android.content.Loader.OnLoadCompleteListener
import android.database.Cursor
import android.os.Bundle
import android.view.Menu
import android.view.View
import android.widget.*
import android.widget.AdapterView.OnItemClickListener
import com.yugioh.android.R
import com.yugioh.android.base.BaseFragment
import com.yugioh.android.base.BaseTabFragment
import com.yugioh.android.loader.SearchLoader
import com.yugioh.android.utils.MiscUtils
import com.yugioh.android.utils.ResourceUtils

class SearchResultFragment : BaseFragment(), OnItemClickListener, OnLoadCompleteListener<Cursor> {

    internal var cSearchResult: Cursor? = null
    internal var adapterSearchResult: SimpleCursorAdapter? = null
    internal var lvList: ListView? = null
    internal var tvListNoCard: TextView? = null
    internal var loaderSearch: SearchLoader? = null

    internal var parentFragment: BaseTabFragment? = null

    init {
        tabTitle = ResourceUtils.getString(R.string.page_list)
    }

    fun registerParent(intf: BaseTabFragment) {
        this.parentFragment = intf
    }

    override fun getBarTitle(): Int = R.string.app_name

    override fun getBarTitleWithPath(): Int = R.string.app_name

    override fun initComponents() {
        lvList = innerView?.findViewById(R.id.lvList) as ListView?
        tvListNoCard = innerView?.findViewById(R.id.tvListNoCard) as TextView?
        loaderSearch = SearchLoader(activity, activity.intent.extras)
    }

    override fun initEvents() {
        lvList?.onItemClickListener = this
        loaderSearch?.registerListener(0, this)
    }

    override fun initLogic() {
        tvListNoCard?.setText(R.string.list_nocard_searching)
        loaderSearch?.startLoading()
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_search_result

    override fun getMainActivityName(): String? = ""

    override fun initMenu(menu: Menu?) {}

    override fun onGetNewArguments(bn: Bundle?) {}

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        MiscUtils.openCardDetail(activity, cSearchResult, position)
    }

    override fun getCustomTitle(): String? = null

    override fun onLoadComplete(loader: Loader<Cursor>?, data: Cursor?) {
        if (data != null) {
            cSearchResult = data
            adapterSearchResult = SimpleCursorAdapter(activity, R.layout.item_card, cSearchResult, arrayOf("name", "sCardType"), intArrayOf(R.id.tvCardName, R.id.tvCardType), CursorAdapter.FLAG_REGISTER_CONTENT_OBSERVER)
        }

        if (activity != null) {
            lvList?.adapter = adapterSearchResult
            tvListNoCard?.visibility = if (adapterSearchResult!!.count == 0) View.VISIBLE else View.GONE
            tvListNoCard?.setText(R.string.list_nocard)
        }
    }

    override fun getFragmentState(): Bundle? = null
}
