package com.rarnu.yugioh.card

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import com.rarnu.android.BackActivity
import com.rarnu.android.runOnMainThread
import com.rarnu.yugioh.CardInfo
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.card.adapter.CardListAdapter
import kotlinx.android.synthetic.main.activity_packdetail.*
import kotlin.concurrent.thread

class PackDetailActivity : BackActivity(), AdapterView.OnItemClickListener {

    private val list = mutableListOf<CardInfo>()
    private lateinit var adapter: CardListAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_packdetail)
        actionBar?.title = intent.getStringExtra("name")
        val url = intent.getStringExtra("url")
        adapter = CardListAdapter(this, list)
        lvPackCard.adapter = adapter
        lvPackCard.onItemClickListener = this
        thread {
            val tmp = YGOData.packageDetail(url)
            list.clear()
            list.addAll(tmp.data)
            runOnMainThread {
                adapter.setNewList(list)
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