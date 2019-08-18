package com.rarnu.yugioh.card

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.AdapterView
import android.widget.ListView
import com.rarnu.android.*
import com.rarnu.yugioh.HotCard
import com.rarnu.yugioh.HotPack
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.card.adapter.SimpleCardAdapter
import com.rarnu.yugioh.card.adapter.SimplePackAdapter
import com.rarnu.yugioh.card.adapter.SimpleSearchAdapter
import kotlinx.android.synthetic.main.activity_main.*
import java.security.KeyStore
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManagerFactory
import kotlin.concurrent.thread

class MainActivity : Activity(), View.OnClickListener, AdapterView.OnItemClickListener {

    private val MENUID_LIMIT = 0
    private val MENUID_PACK = 1
    private val MENUID_DECK = 2

    private val listSearch = mutableListOf<String>()
    private lateinit var adapterSearch: SimpleSearchAdapter
    private val listCard = mutableListOf<HotCard>()
    private lateinit var adapterCard: SimpleCardAdapter
    private val listPack = mutableListOf<HotPack>()
    private lateinit var adapterPack: SimplePackAdapter

    override fun onCreate(savedInstanceState: Bundle?) {

        initUI()
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        btnSearch.setOnClickListener(this)
        btnAdvSearch.setOnClickListener(this)
        if (checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), 0)
        }
        adapterSearch = SimpleSearchAdapter(this, listSearch)
        gvSearch.adapter = adapterSearch
        adapterCard = SimpleCardAdapter(this, listCard)
        lvHotCard.adapter = adapterCard
        adapterPack = SimplePackAdapter(this, listPack)
        lvHotPack.adapter = adapterPack

        gvSearch.onItemClickListener = this
        lvHotCard.onItemClickListener = this
        lvHotPack.onItemClickListener = this
        tvChangeHotCard.setOnClickListener { loadHotest() }

        btnHelp.setOnClickListener(this)
        loadHotest()
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?) {
        if (requestCode == 0) {
            if (grantResults != null) {
                if (grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                    finish()
                }
            }
        }
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.btnSearch -> {
                val key = edtSearch.text.toString()
                if (key == "") {
                    toast(resStr(R.string.toast_empty_search_key))
                    return
                }
                startActivity(Intent(this, CardListActivity::class.java).apply { putExtra("key", key) })
            }
            R.id.btnAdvSearch -> startActivity(Intent(this, SearchActivity::class.java))
            R.id.btnHelp -> startActivity(Intent(this, HelpActivity::class.java))
        }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menu.add(0, MENUID_LIMIT, 0, R.string.card_limit).apply { setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS) }
        menu.add(0, MENUID_PACK, 1, R.string.card_pack).apply { setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS) }
        menu.add(0, MENUID_DECK, 2, R.string.card_deck).apply { setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS) }
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            MENUID_LIMIT -> startActivity(Intent(this, LimitActivity::class.java))
            MENUID_PACK -> startActivity(Intent(this, PackActivity::class.java))
            MENUID_DECK -> startActivity(Intent(this, DeckListActivity::class.java))
        }
        return true
    }

    private fun loadHotest() = thread {
        val ret = YGOData.hotest()
        listSearch.clear()
        listSearch.addAll(ret.search)
        listCard.clear()
        listCard.addAll(ret.card)
        listPack.clear()
        listPack.addAll(ret.pack)
        runOnMainThread {
            adapterSearch.setNewList(listSearch)
            resetGridHeight()
            adapterCard.setNewList(listCard)
            resetListHeight(lvHotCard, listCard.size)
            adapterPack.setNewList(listPack)
            resetListHeight(lvHotPack, listPack.size)
        }
    }


    private fun resetGridHeight() {
        var line = listSearch.size / 5
        if (listSearch.size % 5 != 0) {
            line++
        }
        val lay = gvSearch.layoutParams
        lay.height = (line * 41).dip2px()
        gvSearch.layoutParams = lay
    }

    private fun resetListHeight(lv: ListView, lines: Int) {
        lv.layoutParams = lv.layoutParams.apply { height = (lines * 41).dip2px() }
    }

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        when (parent) {
            gvSearch -> startActivity(Intent(this, CardListActivity::class.java).apply { putExtra("key", listSearch[position]) })
            lvHotCard -> startActivity(Intent(this, CardDetailActivity::class.java).apply {
                putExtra("name", listCard[position].name)
                putExtra("hashid", listCard[position].hashid)
            })
            lvHotPack -> startActivity(Intent(this, PackDetailActivity::class.java).apply {
                putExtra("url", listPack[position].packid)
                putExtra("name", listPack[position].name)
            })
        }
    }
}
