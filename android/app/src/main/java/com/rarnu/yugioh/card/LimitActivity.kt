package com.rarnu.yugioh.card

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import com.rarnu.android.BackActivity
import com.rarnu.android.resStr
import com.rarnu.yugioh.LimitInfo
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.card.adapter.LimitAdapter
import kotlinx.android.synthetic.main.activity_limit.*
import kotlin.concurrent.thread

class LimitActivity : BackActivity(), AdapterView.OnItemClickListener {


    private val list = arrayListOf<LimitInfo>()
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
}