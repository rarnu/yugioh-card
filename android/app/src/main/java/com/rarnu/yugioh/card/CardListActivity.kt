package com.rarnu.yugioh.card

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import com.rarnu.android.BackActivity
import com.rarnu.android.resStr
import com.rarnu.android.runOnMainThread
import com.rarnu.yugioh.CardInfo
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.card.adapter.CardListAdapter
import kotlinx.android.synthetic.main.activity_cardlist.*
import kotlin.concurrent.thread

class CardListActivity : BackActivity(), View.OnClickListener, AdapterView.OnItemClickListener {

    private var key = ""
    private var currentPage = 1
    private var pageCount = 1
    private val list = mutableListOf<CardInfo>()
    private lateinit var adapter: CardListAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_cardlist)
        actionBar?.title = resStr(R.string.card_list)

        adapter = CardListAdapter(this, list)
        lvCard.adapter = adapter
        lvCard.onItemClickListener = this

        btnFirst.setOnClickListener(this)
        btnPrior.setOnClickListener(this)
        btnNext.setOnClickListener(this)
        btnLast.setOnClickListener(this)
        key = intent.getStringExtra("key")
        searchCommon(key, 1)
    }

    private fun searchCommon(key: String, page: Int) = thread {
        val ret = YGOData.searchCommon(key, page)
        currentPage = ret.page
        pageCount = ret.pageCount
        list.clear()
        list.addAll(ret.data)
        runOnMainThread {
            adapter.setNewList(list)
            tvPage.text = "$currentPage / $pageCount"
        }
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
        startActivity(Intent(this, CardDetailActivity::class.java).apply {
            putExtra("name", list[position].name)
            putExtra("hashid", list[position].hashid)
        })
    }

}