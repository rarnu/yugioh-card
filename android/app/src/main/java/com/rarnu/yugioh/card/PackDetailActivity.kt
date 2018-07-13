package com.rarnu.yugioh.card

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.MenuItem
import android.view.View
import android.widget.AdapterView
import com.rarnu.kt.android.showActionBack
import com.rarnu.yugioh.CardInfo
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.card.adapter.CardListAdapter
import kotlinx.android.synthetic.main.activity_packdetail.*
import kotlin.concurrent.thread

class PackDetailActivity : Activity(), AdapterView.OnItemClickListener {


    private val list = arrayListOf<CardInfo>()
    private lateinit var adapter: CardListAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_packdetail)
        actionBar.title = intent.getStringExtra("name")
        showActionBack()
        val url = intent.getStringExtra("url")
        adapter = CardListAdapter(this, list)
        lvPackCard.adapter = adapter
        lvPackCard.onItemClickListener = this

        thread {
            val tmp = YGOData.packageDetail(url)
            list.clear()
            list.addAll(tmp.data)
            runOnUiThread {
                adapter.setNewList(list)
            }
        }
    }

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        val hashid = list[position].hashid
        val name = list[position].name
        val inDetail = Intent(this, CardDetailActivity::class.java)
        inDetail.putExtra("name", name)
        inDetail.putExtra("hashid", hashid)
        startActivity(inDetail)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when(item.itemId) {
            android.R.id.home -> finish()
        }
        return true
    }
}