package com.yugioh.android.fragments

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.AdapterView
import android.widget.AdapterView.OnItemSelectedListener
import android.widget.ArrayAdapter
import android.widget.Spinner
import com.rarnu.base.app.BaseFragment
import com.rarnu.base.utils.ResourceUtils
import com.yugioh.android.LinkOptionActivity
import com.yugioh.android.R
import com.yugioh.android.SearchResultActivity
import com.yugioh.android.common.MenuIds
import com.yugioh.android.define.CardConstDefine
import kotlinx.android.synthetic.main.fragment_search.view.*
import kotlin.concurrent.thread

@Suppress("UNCHECKED_CAST")
class SearchFragment : BaseFragment(), OnItemSelectedListener, View.OnClickListener {

    internal var itemSearch: MenuItem? = null
    internal var itemReset: MenuItem? = null
    internal var linkCount = 1
    internal var linkArrow = ""

    init {
        tabTitle = ResourceUtils.getString(R.string.page_search)
    }

    override fun getBarTitle(): Int = R.string.app_name

    override fun getBarTitleWithPath(): Int = R.string.app_name

    override fun initComponents() {
        innerView.etCardName.requestFocus()
    }

    override fun initEvents() {
        innerView.btnLink.setOnClickListener(this)
    }

    override fun initLogic() {
        setSpinner(innerView.spCardRace, CardConstDefine.DEFID_CARDRACE)
        setSpinner(innerView.spCardBelongs, CardConstDefine.DEFID_CARDBELONGS)
        setSpinner(innerView.spCardType, CardConstDefine.DEFID_CARDTYPE)
        setSpinner(innerView.spCardAttribute, CardConstDefine.DEFID_CARDATTRITUBE)
        setSpinner(innerView.spCardLevel, CardConstDefine.DEFID_CARDLEVEL)
        setSpinner(innerView.spCardRare, CardConstDefine.DEFID_CARDRARE)
        setSpinner(innerView.spCardLimit, CardConstDefine.DEFID_CARDLIMIT)
        setSpinner(innerView.spCardTunner, CardConstDefine.DEFID_CARDTUNNER)
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

    override fun initMenu(menu: Menu) {
        itemSearch = menu.add(0, MenuIds.MENUID_SEARCH, 98, R.string.search_search)
        itemSearch?.setIcon(android.R.drawable.ic_menu_search)
        itemSearch?.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
        itemReset = menu.add(0, MenuIds.MENUID_RESET, 99, R.string.search_reset)
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
        val cardName = innerView.etCardName.text.toString()
        var cardType = ""
        if (innerView.spCardType.selectedItemPosition != 0) {
            cardType = innerView.spCardType.selectedItem as String
        }
        var cardAttribute = ""
        if (innerView.spCardAttribute.selectedItemPosition != 0) {
            cardAttribute = innerView.spCardAttribute.selectedItem as String
        }
        var cardLevel = 0
        if (innerView.spCardLevel.selectedItemPosition != 0) {
            cardLevel = Integer.parseInt(innerView.spCardLevel.selectedItem as String)
        }
        var cardRare = ""
        if (innerView.spCardRare.selectedItemPosition != 0) {
            cardRare = innerView.spCardRare.selectedItem as String
        }
        var cardRace = ""
        if (innerView.spCardRace.selectedItemPosition != 0) {
            cardRace = innerView.spCardRace.selectedItem as String
        }
        var cardBelongs = ""
        if (innerView.spCardBelongs.selectedItemPosition != 0) {
            cardBelongs = innerView.spCardBelongs.selectedItem as String
        }
        val cardAtk = innerView.etCardAttack.text.toString()
        val cardDef = innerView.etCardDefense.text.toString()

        var cardLimit = ""
        if (innerView.spCardLimit.selectedItemPosition != 0) {
            cardLimit = innerView.spCardLimit.selectedItem as String
        }

        var cardTunner = innerView.spCardTunner.selectedItem as String
        if (cardTunner == getString(R.string.search_na)) {
            cardTunner = ""
        }

        val cardEffect = innerView.etEffectText.text.toString()

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
        bn.putInt("cardLink", linkCount)
        bn.putString("cardLinkArrow", linkArrow)
        val inResult = Intent(activity, SearchResultActivity::class.java)
        inResult.putExtras(bn)
        startActivity(inResult)
    }

    private fun doSearchReset() {
        innerView.spCardAttribute.setSelection(0)
        innerView.spCardBelongs.setSelection(0)
        innerView.spCardLevel.setSelection(0)
        innerView.spCardLimit.setSelection(0)
        innerView.spCardRace.setSelection(0)
        innerView.spCardRare.setSelection(0)
        innerView.spCardTunner.setSelection(0)
        innerView.spCardType.setSelection(0)
        innerView.etCardName.setText("")
        innerView.etCardAttack.setText("")
        innerView.etCardDefense.setText("")
        innerView.etEffectText.setText("")
    }

    override fun onGetNewArguments(bn: Bundle?) {
        if (bn != null) {
            if (bn.getString("data") == "search") {
                doSearchCard()
            } else if (bn.getString("data") == "reset") {
                doSearchReset()
            }
        }
    }

    override fun onItemSelected(parent: AdapterView<*>, view: View, position: Int, id: Long) {
        when (parent.id) {
            R.id.spCardType -> {
                linkCount = 0
                linkArrow = ""
                innerView.btnLink.text = getString(R.string.search_link)
                innerView.spCardTunner.setSelection(0)
                innerView.spCardTunner.isEnabled = position in 1..7
                innerView.btnLink.visibility = if (position == 8) View.VISIBLE else View.GONE
                innerView.spCardTunner.visibility = if (position != 8) View.VISIBLE else View.GONE
            }
        }
    }

    override fun onNothingSelected(parent: AdapterView<*>) {}

    override fun getCustomTitle(): String? = null

    override fun getFragmentState(): Bundle? = null

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (resultCode != Activity.RESULT_OK) {
            return
        }
        when (requestCode) {
            0 -> innerView.etCardName.setText(data?.getStringExtra("name"))
            1 -> {
                linkCount = data!!.getIntExtra("count", 0)
                linkArrow = data.getStringExtra("arrow")
                innerView.btnLink.text = "$linkCount(${linkArrow
                        .replace("1", CardConstDefine.linkArrow[0])
                        .replace("2", CardConstDefine.linkArrow[1])
                        .replace("3", CardConstDefine.linkArrow[2])
                        .replace("4", CardConstDefine.linkArrow[3])
                        .replace("6", CardConstDefine.linkArrow[5])
                        .replace("7", CardConstDefine.linkArrow[6])
                        .replace("8", CardConstDefine.linkArrow[7])
                        .replace("9", CardConstDefine.linkArrow[8])})"
            }
        }
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.btnLink -> {
                val inLink = Intent(activity, LinkOptionActivity::class.java)
                inLink.putExtra("count", linkCount)
                inLink.putExtra("arrow", linkArrow)
                startActivityForResult(inLink, 1)
            }
        }
    }

}
