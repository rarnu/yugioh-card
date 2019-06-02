package com.rarnu.yugioh.card

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.AdapterView
import android.widget.ListView
import com.rarnu.android.dip2px
import com.rarnu.android.initUI
import com.rarnu.android.resStr
import com.rarnu.android.toast
import com.rarnu.yugioh.HotCard
import com.rarnu.yugioh.HotPack
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.card.adapter.SimpleCardAdapter
import com.rarnu.yugioh.card.adapter.SimplePackAdapter
import com.rarnu.yugioh.card.adapter.SimpleSearchAdapter
import kotlinx.android.synthetic.main.activity_main.*
import kotlin.concurrent.thread

class MainActivity : Activity(), View.OnClickListener, AdapterView.OnItemClickListener {

    private val MENUID_LIMIT = 0
    private val MENUID_PACK = 1

    private val listSearch = arrayListOf<String>()
    private lateinit var adapterSearch: SimpleSearchAdapter
    private val listCard = arrayListOf<HotCard>()
    private lateinit var adapterCard: SimpleCardAdapter
    private val listPack = arrayListOf<HotPack>()
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

        Updater.checkUpdate(this)
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
                val inSearch = Intent(this, CardListActivity::class.java)
                inSearch.putExtra("key", key)
                startActivity(inSearch)
            }
            R.id.btnAdvSearch -> startActivity(Intent(this, SearchActivity::class.java))
            R.id.btnHelp -> startActivity(Intent(this, HelpActivity::class.java))
        }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val mLimit = menu.add(0, MENUID_LIMIT, 0, R.string.card_limit)
        mLimit.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
        val mPack = menu.add(0, MENUID_PACK, 1, R.string.card_pack)
        mPack.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            MENUID_LIMIT -> startActivity(Intent(this, LimitActivity::class.java))
            MENUID_PACK -> startActivity(Intent(this, PackActivity::class.java))
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
        runOnUiThread {
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
        val lay = lv.layoutParams
        lay.height = (lines * 41).dip2px()
        lv.layoutParams = lay
    }

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        when (parent) {
            gvSearch -> {
                val inSearch = Intent(this, CardListActivity::class.java)
                inSearch.putExtra("key", listSearch[position])
                startActivity(inSearch)
            }
            lvHotCard -> {
                val hashid = listCard[position].hashid
                val name = listCard[position].name
                val inDetail = Intent(this, CardDetailActivity::class.java)
                inDetail.putExtra("name", name)
                inDetail.putExtra("hashid", hashid)
                startActivity(inDetail)
            }
            lvHotPack -> {
                val pack = listPack[position]
                val inDetail = Intent(this, PackDetailActivity::class.java)
                inDetail.putExtra("url", pack.packid)
                inDetail.putExtra("name", pack.name)
                startActivity(inDetail)
            }
        }
    }
}
