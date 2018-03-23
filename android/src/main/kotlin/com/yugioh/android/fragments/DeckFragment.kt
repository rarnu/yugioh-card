package com.yugioh.android.fragments

import android.content.Intent
import android.content.Loader
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.view.Menu
import android.view.View
import android.widget.AdapterView
import android.widget.Toast
import com.rarnu.base.app.BaseFragment
import com.yugioh.android.DeckCardActivity
import com.yugioh.android.R
import com.yugioh.android.adapter.DeckAdapter
import com.yugioh.android.classes.CardItems
import com.yugioh.android.classes.DeckItem
import com.yugioh.android.loader.DeckLoader
import com.yugioh.android.utils.MiscUtils
import kotlinx.android.synthetic.main.fragment_deck.view.*

class DeckFragment : BaseFragment(), AdapterView.OnItemClickListener, Loader.OnLoadCompleteListener<MutableList<DeckItem>?> {

    internal var adapter: DeckAdapter? = null
    internal var list: MutableList<DeckItem>? = null
    internal var loader: DeckLoader? = null

    override fun getBarTitle(): Int = R.string.lm_deck

    override fun getBarTitleWithPath(): Int = R.string.lm_deck

    override fun getCustomTitle(): String? = null

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_deck

    override fun getMainActivityName(): String? = ""

    override fun initComponents() {
        loader = DeckLoader(activity)
        list = arrayListOf()
        adapter = DeckAdapter(activity, list)
        innerView.lvDeck.adapter = adapter
    }

    override fun initEvents() {
        loader?.registerListener(0, this)
        innerView.lvDeck.onItemClickListener = this
    }

    override fun initLogic() {
        innerView.tvLoading.visibility = View.VISIBLE
        innerView.tvListNoDeck.setText(R.string.list_nocard_searching)
        loader?.startLoading()
    }

    override fun initMenu(menu: Menu) { }

    override fun onGetNewArguments(bn: Bundle?) { }

    override fun getFragmentState(): Bundle? = null

    override fun onItemClick(parent: AdapterView<*>, view: View, position: Int, id: Long) {
        innerView.lvDeck.isEnabled = false
        innerView.tvLoading.visibility = View.VISIBLE
        val (id1) = list!![position]
        MiscUtils.loadCardsDataT(1, id1, false) {
            activity.runOnUiThread {
                innerView.lvDeck.isEnabled = true
                innerView.tvLoading.visibility = View.GONE
                val bn = Bundle()
                if (it != null) {
                    bn.putIntArray("ids", it.cardIds)
                    bn.putString("pack", it.packageName)
                    val inCards = Intent(activity, DeckCardActivity::class.java)
                    inCards.putExtras(bn)
                    startActivity(inCards)
                } else {
                    Toast.makeText(activity, R.string.package_cannot_load, Toast.LENGTH_LONG).show()
                }
            }
        }
    }

    override fun onLoadComplete(loader: Loader<MutableList<DeckItem>?>?, data: MutableList<DeckItem>?) {
        list?.clear()
        if (data != null) {
            list?.addAll(data)
        }
        if (activity != null) {
            adapter?.setNewList(list)
            innerView.tvLoading.visibility = View.GONE
            innerView.tvListNoDeck.visibility = if (list!!.size == 0) View.VISIBLE else View.GONE
            innerView.tvListNoDeck.setText(R.string.deck_nocard)
        }
    }
}
