package com.rarnu.yugioh.card

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.MenuItem
import android.view.View
import android.widget.AdapterView
import com.rarnu.kt.android.resStr
import com.rarnu.kt.android.showActionBack
import com.rarnu.yugioh.CardInfo
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.card.adapter.CardListAdapter
import kotlinx.android.synthetic.main.activity_cardlist.*
import kotlin.concurrent.thread

class CardListActivity : Activity(), View.OnClickListener, AdapterView.OnItemClickListener {


    private var key = ""
    private var currentPage = 1
    private var pageCount = 1
    private val list = arrayListOf<CardInfo>()
    private lateinit var adapter: CardListAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_cardlist)
        actionBar.title = resStr(R.string.card_list)
        showActionBack()

        adapter = CardListAdapter(this, list)
        lvCard.adapter = adapter
        lvCard.onItemClickListener = this

        btnFirst.setOnClickListener(this)
        btnPrior.setOnClickListener(this)
        btnNext.setOnClickListener(this)
        btnLast.setOnClickListener(this)

        val type = intent.getIntExtra("type", 0)
        when (type) {
            0 -> key = intent.getStringExtra("key")
            1 -> {
                // complex search
            }
            2 -> {
                // card pack
            }
        }
        searchCommon(key, 1)
    }

    private fun searchCommon(key: String, page: Int) = thread {
        val ret = YGOData.searchCommon(key, page)
        currentPage = ret.page
        pageCount = ret.pageCount
        list.clear()
        list.addAll(ret.data)
        runOnUiThread {
            adapter.setNewList(list)
            tvPage.text = "$currentPage / $pageCount"
        }
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            android.R.id.home -> finish()
        }
        return true
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.btnFirst -> {
                if (currentPage != 1) {
                    currentPage = 1
                    searchCommon(key, currentPage)
                }
            }
            R.id.btnPrior -> {
                if (currentPage > 1) {
                    currentPage--
                    searchCommon(key, currentPage)
                }
            }
            R.id.btnNext -> {
                if (currentPage < pageCount) {
                    currentPage++
                    searchCommon(key, currentPage)
                }
            }
            R.id.btnLast -> {
                if (currentPage != pageCount) {
                    currentPage = pageCount
                    searchCommon(key, currentPage)
                }
            }
        }
    }

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        val hashid = list[position].hashid
        val name = list[position].name
        val cardid = list[position].cardid
        val inDetail = Intent(this, CardDetailActivity::class.java)
        inDetail.putExtra("name", name)
        inDetail.putExtra("hashid", hashid)
        inDetail.putExtra("cardid", cardid)
        startActivity(inDetail)
    }

}