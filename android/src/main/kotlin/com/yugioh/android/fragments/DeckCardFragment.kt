package com.yugioh.android.fragments

import android.content.Loader
import android.database.Cursor
import android.os.Bundle
import android.view.Menu
import android.view.View
import android.widget.*
import com.yugioh.android.R
import com.rarnu.base.app.BaseFragment
import com.yugioh.android.loader.SearchLoader
import com.yugioh.android.utils.MiscUtils
import kotlinx.android.synthetic.main.fragment_deck_cards.view.*

class DeckCardFragment : BaseFragment(), Loader.OnLoadCompleteListener<Cursor>, AdapterView.OnItemClickListener {

    internal var loader: SearchLoader? = null
    private var cSearchResult: Cursor? = null
    private var adapterSearchResult: SimpleCursorAdapter? = null

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun getCustomTitle(): String? = arguments.getString("name")

    override fun initComponents() {
        loader = SearchLoader(activity, arguments)
    }

    override fun initEvents() {
        loader?.registerListener(0, this)
        innerView.lvCards.onItemClickListener = this
    }

    override fun initLogic() {
        innerView.tvListNoCard.setText(R.string.list_nocard_searching)
        loader?.startLoading()
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_deck_cards

    override fun getMainActivityName(): String? = null

    override fun initMenu(menu: Menu) { }

    override fun onGetNewArguments(bn: Bundle?) {}

    override fun getFragmentState(): Bundle? = null

    override fun onLoadComplete(loader: Loader<Cursor>?, data: Cursor?) {
        if (data != null) {
            cSearchResult = data
            adapterSearchResult = SimpleCursorAdapter(activity, R.layout.item_card, cSearchResult, arrayOf("name", "sCardType"), intArrayOf(R.id.tvCardName, R.id.tvCardType), CursorAdapter.FLAG_REGISTER_CONTENT_OBSERVER)
        }
        if (activity != null) {
            innerView.lvCards.adapter = adapterSearchResult
            innerView.tvListNoCard.visibility = if (adapterSearchResult!!.count == 0) View.VISIBLE else View.GONE
            innerView.tvListNoCard.setText(R.string.deck_nocard)
        }
    }

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        MiscUtils.openCardDetail(activity, cSearchResult, position)
    }
}
