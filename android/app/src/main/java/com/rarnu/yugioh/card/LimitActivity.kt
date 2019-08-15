package com.rarnu.yugioh.card

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import com.rarnu.android.BackActivity
import com.rarnu.android.resStr
import com.rarnu.android.runOnMainThread
import com.rarnu.yugioh.LimitInfo
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.card.adapter.LimitAdapter
import kotlinx.android.synthetic.main.activity_limit.*
import kotlin.concurrent.thread

class LimitActivity : BackActivity(), AdapterView.OnItemClickListener {


    private val list = mutableListOf<LimitInfo>()
    private lateinit var adapter: LimitAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_limit)
        actionBar?.title = resStr(R.string.card_limit_full)
        adapter = LimitAdapter(this, list)
        lvLimit.adapter = adapter
        lvLimit.onItemClickListener = this

        thread {
            val ret = YGOData.limit()
            list.clear()
            list.addAll(ret)
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