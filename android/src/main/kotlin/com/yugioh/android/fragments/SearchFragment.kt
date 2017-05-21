package com.yugioh.android.fragments

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.*
import android.widget.AdapterView.OnItemSelectedListener
import com.yugioh.android.R
import com.yugioh.android.SearchResultActivity
import com.yugioh.android.base.BaseFragment
import com.yugioh.android.common.MenuIds
import com.yugioh.android.define.CardConstDefine
import com.yugioh.android.utils.ResourceUtils
import kotlin.concurrent.thread

class SearchFragment : BaseFragment(), OnItemSelectedListener, View.OnClickListener {


    internal var spCardRace: Spinner? = null
    internal var spCardBelongs: Spinner? = null
    internal var spCardType: Spinner? = null
    internal var spCardAttribute: Spinner? = null
    internal var spCardLevel: Spinner? = null
    internal var spCardRare: Spinner? = null
    internal var spCardLimit: Spinner? = null
    internal var spCardTunner: Spinner? = null
    internal var btnLink: Button? = null
    internal var etCardName: EditText? = null
    internal var etCardAttack: EditText? = null
    internal var etCardDefense: EditText? = null
    internal var etEffectText: EditText? = null
    internal var itemSearch: MenuItem? = null
    internal var itemReset: MenuItem? = null

    private var searchResultFragment: BaseFragment? = null

    init {
        tabTitle = ResourceUtils.getString(R.string.page_search)
    }

    fun registerSearchResult(intf: BaseFragment) {
        this.searchResultFragment = intf
    }

    override fun getBarTitle(): Int = R.string.app_name

    override fun getBarTitleWithPath(): Int = R.string.app_name

    override fun initComponents() {
        etCardName = innerView?.findViewById(R.id.etCardName) as EditText?
        etCardAttack = innerView?.findViewById(R.id.etCardAttack) as EditText?
        etCardDefense = innerView?.findViewById(R.id.etCardDefense) as EditText?
        etEffectText = innerView?.findViewById(R.id.etEffectText) as EditText?
        spCardRace = innerView?.findViewById(R.id.spCardRace) as Spinner?
        spCardBelongs = innerView?.findViewById(R.id.spCardBelongs) as Spinner?
        spCardType = innerView?.findViewById(R.id.spCardType) as Spinner?
        spCardAttribute = innerView?.findViewById(R.id.spCardAttribute) as Spinner?
        spCardLevel = innerView?.findViewById(R.id.spCardLevel) as Spinner?
        spCardRare = innerView?.findViewById(R.id.spCardRare) as Spinner?
        spCardLimit = innerView?.findViewById(R.id.spCardLimit) as Spinner?
        spCardTunner = innerView?.findViewById(R.id.spCardTunner) as Spinner?
        btnLink = innerView?.findViewById(R.id.btnLink) as Button?
        etCardName?.requestFocus()
    }

    override fun initEvents() {
        btnLink?.setOnClickListener(this)
    }

    override fun initLogic() {
        setSpinner(spCardRace, CardConstDefine.DEFID_CARDRACE)
        setSpinner(spCardBelongs, CardConstDefine.DEFID_CARDBELONGS)
        setSpinner(spCardType, CardConstDefine.DEFID_CARDTYPE)
        setSpinner(spCardAttribute, CardConstDefine.DEFID_CARDATTRITUBE)
        setSpinner(spCardLevel, CardConstDefine.DEFID_CARDLEVEL)
        setSpinner(spCardRare, CardConstDefine.DEFID_CARDRARE)
        setSpinner(spCardLimit, CardConstDefine.DEFID_CARDLIMIT)
        setSpinner(spCardTunner, CardConstDefine.DEFID_CARDTUNNER)

    }

    private fun setSpinner(sp: Spinner?, type: Int) {
        sp?.onItemSelectedListener = this

        val hSpin = object : Handler() {
            override fun handleMessage(msg: Message) {
                if (msg.what == 1) {
                    val list = msg.obj as List<String>?
                    if (list != null) {
                        val adapter = ArrayAdapter(activity, R.layout.item_spin, list)
                        sp?.adapter = adapter
                        sp?.setSelection(0)
                    }
                }
                super.handleMessage(msg)
            }
        }

        thread {
            var list: MutableList<String>? = null
            when (type) {
                CardConstDefine.DEFID_CARDRACE -> {
                    list = CardConstDefine.cardRace
                    list.add(0, resources.getString(R.string.search_na))
                }
                CardConstDefine.DEFID_CARDBELONGS -> list = CardConstDefine.cardBelongs
                CardConstDefine.DEFID_CARDTYPE -> {
                    list = CardConstDefine.cardType
                    list.add(0, resources.getString(R.string.search_na))
                }

                CardConstDefine.DEFID_CARDATTRITUBE -> {
                    list = CardConstDefine.cardAttribute
                    list.add(0, resources.getString(R.string.search_na))
                }

                CardConstDefine.DEFID_CARDLEVEL -> {
                    list = CardConstDefine.cardLevel
                    list.add(0, resources.getString(R.string.search_na))
                }

                CardConstDefine.DEFID_CARDRARE -> {
                    list = CardConstDefine.cardCare
                    list.add(0, resources.getString(R.string.search_na))
                }

                CardConstDefine.DEFID_CARDLIMIT -> {
                    list = CardConstDefine.cardLimit
                    list.add(0, resources.getString(R.string.search_na))
                }
                CardConstDefine.DEFID_CARDTUNNER -> {
                    list = CardConstDefine.cardTunner
                    list.add(0, resources.getString(R.string.search_na))
                }
            }

            val msg = Message()
            msg.what = 1
            msg.obj = list
            hSpin.sendMessage(msg)
        }

    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_search

    override fun getMainActivityName(): String? = ""


    override fun initMenu(menu: Menu?) {
        itemSearch = menu?.add(0, MenuIds.MENUID_SEARCH, 98, R.string.search_search)
        itemSearch?.setIcon(android.R.drawable.ic_menu_search)
        itemSearch?.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
        itemReset = menu?.add(0, MenuIds.MENUID_RESET, 99, R.string.search_reset)
        itemReset?.setIcon(android.R.drawable.ic_menu_close_clear_cancel)
        itemReset?.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            MenuIds.MENUID_SEARCH -> doSearchCard()
            MenuIds.MENUID_RESET -> doSearchReset()
        }
        return true
    }

    private fun doSearchCard() {
        val cardName = etCardName?.text.toString()
        var cardType = ""
        if (spCardType?.selectedItemPosition != 0) {
            cardType = spCardType?.selectedItem as String
        }
        var cardAttribute = ""
        if (spCardAttribute?.selectedItemPosition != 0) {
            cardAttribute = spCardAttribute?.selectedItem as String
        }
        var cardLevel = 0
        if (spCardLevel?.selectedItemPosition != 0) {
            cardLevel = Integer.parseInt(spCardLevel?.selectedItem as String)
        }
        var cardRare = ""
        if (spCardRare?.selectedItemPosition != 0) {
            cardRare = spCardRare?.selectedItem as String
        }
        var cardRace = ""
        if (spCardRace?.selectedItemPosition != 0) {
            cardRace = spCardRace?.selectedItem as String
        }
        var cardBelongs = ""
        if (spCardBelongs?.selectedItemPosition != 0) {
            cardBelongs = spCardBelongs?.selectedItem as String
        }
        val cardAtk = etCardAttack?.text.toString()
        val cardDef = etCardDefense?.text.toString()

        var cardLimit = ""
        if (spCardLimit?.selectedItemPosition != 0) {
            cardLimit = spCardLimit?.selectedItem as String
        }

        var cardTunner = spCardTunner?.selectedItem as String
        if (cardTunner == getString(R.string.search_na)) {
            cardTunner = ""
        }

        val cardEffect = etEffectText?.text.toString()

        val bn = Bundle()
        bn.putString("cardType", cardType)
        bn.putString("cardAttribute", cardAttribute)
        bn.putInt("cardLevel", cardLevel)
        bn.putString("cardRace", cardRace)
        bn.putString("cardName", cardName)
        bn.putString("cardEffect", cardEffect)
        bn.putString("cardAtk", cardAtk)
        bn.putString("cardDef", cardDef)
        bn.putString("cardRare", cardRare)
        bn.putString("cardBelongs", cardBelongs)
        bn.putString("cardLimit", cardLimit)
        bn.putString("cardTunner", cardTunner)

        val inResult = Intent(activity, SearchResultActivity::class.java)
        inResult.putExtras(bn)
        startActivity(inResult)
    }

    private fun doSearchReset() {
        spCardAttribute?.setSelection(0)
        spCardBelongs?.setSelection(0)
        spCardLevel?.setSelection(0)
        spCardLimit?.setSelection(0)
        spCardRace?.setSelection(0)
        spCardRare?.setSelection(0)
        spCardTunner?.setSelection(0)
        spCardType?.setSelection(0)
        etCardName?.setText("")
        etCardAttack?.setText("")
        etCardDefense?.setText("")
        etEffectText?.setText("")
    }

    override fun onGetNewArguments(bn: Bundle?) {
        if (bn!!.getString("data") == "search") {
            doSearchCard()
        } else if (bn.getString("data") == "reset") {
            doSearchReset()
        }
    }

    override fun onItemSelected(parent: AdapterView<*>, view: View, position: Int, id: Long) {
        when (parent.id) {
            R.id.spCardType -> {
                spCardTunner?.setSelection(0)
                spCardTunner?.isEnabled = position in 1..7
                btnLink?.visibility = if (position == 8) View.VISIBLE else View.GONE
                spCardTunner?.visibility = if (position != 8) View.VISIBLE else View.GONE
            }
        }
    }

    override fun onNothingSelected(parent: AdapterView<*>) {

    }

    override fun getCustomTitle(): String? = null

    override fun getFragmentState(): Bundle? = null

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        if (resultCode != Activity.RESULT_OK) {
            return
        }
        when (requestCode) {
            0 -> etCardName?.setText(data.getStringExtra("name"))
        }
    }

    override fun onClick(v: View) {
        when(v.id) {
            R.id.btnLink -> {
                // TODO: search link
            }
        }
    }
}
