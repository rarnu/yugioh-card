package com.yugioh.android.fragments

import android.content.Intent
import android.content.Loader
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.view.Menu
import android.view.View
import android.widget.AdapterView
import android.widget.ListView
import android.widget.TextView
import android.widget.Toast
import com.yugioh.android.DeckCardActivity
import com.yugioh.android.R
import com.yugioh.android.adapter.DeckAdapter
import com.yugioh.android.base.BaseFragment
import com.yugioh.android.classes.CardItems
import com.yugioh.android.classes.DeckItem
import com.yugioh.android.loader.DeckLoader
import com.yugioh.android.utils.MiscUtils

import java.util.ArrayList

class DeckFragment : BaseFragment(), AdapterView.OnItemClickListener, Loader.OnLoadCompleteListener<MutableList<DeckItem>?> {

    internal var adapter: DeckAdapter? = null
    internal var list: MutableList<DeckItem>? = null
    internal var lvDeck: ListView? = null
    internal var tvListNoDeck: TextView? = null
    internal var tvLoading: TextView? = null
    internal var loader: DeckLoader? = null

    private val hDeck = object : Handler() {
        override fun handleMessage(msg: Message) {
            if (msg.what == 1) {
                lvDeck?.isEnabled = true
                tvLoading?.visibility = View.GONE
                val bn = Bundle()
                val items = msg.obj as CardItems?
                if (items != null) {
                    bn.putIntArray("ids", items.cardIds)
                    bn.putString("pack", items.packageName)
                    val inCards = Intent(activity, DeckCardActivity::class.java)
                    inCards.putExtras(bn)
                    startActivity(inCards)
                } else {
                    Toast.makeText(activity, R.string.package_cannot_load, Toast.LENGTH_LONG).show()
                }
            }
            super.handleMessage(msg)
        }
    }

    override fun getBarTitle(): Int = R.string.lm_deck

    override fun getBarTitleWithPath(): Int = R.string.lm_deck

    override fun getCustomTitle(): String? = null

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_deck

    override fun getMainActivityName(): String? = ""

    override fun initComponents() {
        lvDeck = innerView?.findViewById(R.id.lvDeck) as ListView?
        tvListNoDeck = innerView?.findViewById(R.id.tvListNoDeck) as TextView?
        tvLoading = innerView?.findViewById(R.id.tvLoading) as TextView?
        loader = DeckLoader(activity)
        list = arrayListOf()
        adapter = DeckAdapter(activity, list)
        lvDeck?.adapter = adapter
    }

    override fun initEvents() {
        loader?.registerListener(0, this)
        lvDeck?.onItemClickListener = this
    }

    override fun initLogic() {
        tvLoading?.visibility = View.VISIBLE
        tvListNoDeck?.setText(R.string.list_nocard_searching)
        loader?.startLoading()
    }

    override fun initMenu(menu: Menu?) {
    }

    override fun onGetNewArguments(bn: Bundle?) {
    }

    override fun getFragmentState(): Bundle? = null

    override fun onItemClick(parent: AdapterView<*>, view: View, position: Int, id: Long) {
        lvDeck?.isEnabled = false
        tvLoading?.visibility = View.VISIBLE
        val (id1) = list!![position]
        MiscUtils.loadCardsDataT(1, id1, hDeck, false)
    }

    override fun onLoadComplete(loader: Loader<MutableList<DeckItem>?>?, data: MutableList<DeckItem>?) {
        list?.clear()
        if (data != null) {
            list?.addAll(data)
        }
        if (activity != null) {
            adapter?.setNewList(list)
            tvLoading?.visibility = View.GONE
            tvListNoDeck?.visibility = if (list!!.size == 0) View.VISIBLE else View.GONE
            tvListNoDeck?.setText(R.string.deck_nocard)
        }
    }
}
