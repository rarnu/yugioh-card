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
import com.yugioh.android.loader.NewCardLoader
import com.yugioh.android.utils.MiscUtils
import kotlinx.android.synthetic.main.fragment_newcard.view.*

class NewCardFragment : BaseFragment(), OnItemClickListener, OnLoadCompleteListener<Cursor> {

    internal var cNewCard: Cursor? = null
    internal var adapterNewCard: SimpleCursorAdapter? = null
    internal var loaderNewcard: NewCardLoader? = null

    override fun getBarTitle(): Int = R.string.lm_newcard

    override fun getBarTitleWithPath(): Int = R.string.lm_newcard

    override fun getCustomTitle(): String? = null

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_newcard

    override fun getMainActivityName(): String? = ""

    override fun initComponents() {
        loaderNewcard = NewCardLoader(activity)
    }

    override fun initEvents() {
        innerView.lvNewCard.onItemClickListener = this
        loaderNewcard?.registerListener(0, this)
    }

    override fun initLogic() {
        loaderNewcard?.startLoading()
    }

    override fun initMenu(menu: Menu) { }

    override fun onGetNewArguments(bn: Bundle?) { }

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        MiscUtils.openCardDetail(activity, cNewCard, position)
    }

    override fun onLoadComplete(loader: Loader<Cursor>?, data: Cursor?) {
        if (data != null) {
            cNewCard = data
            adapterNewCard = SimpleCursorAdapter(activity, R.layout.item_card, cNewCard, arrayOf("name", "sCardType"), intArrayOf(R.id.tvCardName, R.id.tvCardType), CursorAdapter.FLAG_REGISTER_CONTENT_OBSERVER)
        }
        if (activity != null) {
            innerView.lvNewCard.adapter = adapterNewCard
        }
    }

    override fun getFragmentState(): Bundle? = null
}
