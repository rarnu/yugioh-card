package com.yugioh.android.fragments

import android.content.Loader
import android.content.Loader.OnLoadCompleteListener
import android.database.Cursor
import android.os.Bundle
import android.view.Menu
import android.view.View
import android.widget.AdapterView
import android.widget.AdapterView.OnItemClickListener
import android.widget.CursorAdapter
import android.widget.ListView
import android.widget.SimpleCursorAdapter
import com.yugioh.android.R
import com.rarnu.base.app.BaseFragment
import com.yugioh.android.loader.LimitLoader
import com.yugioh.android.utils.MiscUtils
import kotlinx.android.synthetic.main.fragment_limit_detail.view.*

open class LimitDetailFragment : BaseFragment(), OnItemClickListener, OnLoadCompleteListener<Cursor> {

    protected var detailType: Int = 0
    internal var cLimit: Cursor? = null
    internal var adapterLimit: SimpleCursorAdapter? = null
    internal var loaderLimit: LimitLoader? = null

    override fun getBarTitle(): Int = R.string.lm_banned

    override fun getBarTitleWithPath(): Int = R.string.lm_banned

    override fun getCustomTitle(): String? = null

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_limit_detail

    override fun getMainActivityName(): String? = ""

    override fun initComponents() {
        loaderLimit = LimitLoader(activity, detailType)
    }

    override fun initEvents() {
        innerView.lvLimitCard.onItemClickListener = this
        loaderLimit?.registerListener(0, this)
    }

    override fun initLogic() {
        loaderLimit?.startLoading()
    }

    override fun initMenu(menu: Menu) { }

    override fun onGetNewArguments(bn: Bundle?) { }

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        MiscUtils.openCardDetail(activity, cLimit, position)
    }

    override fun onLoadComplete(loader: Loader<Cursor>?, data: Cursor?) {
        if (data != null) {
            cLimit = data
            adapterLimit = SimpleCursorAdapter(activity, R.layout.item_card, cLimit, arrayOf("name", "sCardType"), intArrayOf(R.id.tvCardName, R.id.tvCardType), CursorAdapter.FLAG_REGISTER_CONTENT_OBSERVER)
        }
        if (activity != null) {
            innerView.lvLimitCard.adapter = adapterLimit
        }
    }

    override fun getFragmentState(): Bundle? = null
}
