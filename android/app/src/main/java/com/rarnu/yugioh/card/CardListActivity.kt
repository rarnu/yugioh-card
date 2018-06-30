package com.rarnu.yugioh.card

import android.app.Activity
import android.os.Bundle
import com.rarnu.yugioh.card.adapter.CardListAdapter
import com.rarnu.yugioh.card.data.CardListInfo
import kotlinx.android.synthetic.main.activity_cardlist.*

class CardListActivity : Activity() {

    private lateinit var adapter: CardListAdapter
    private var list = mutableListOf<CardListInfo>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_cardlist)

        val key = intent.getStringExtra("key")
        adapter = CardListAdapter(this, list)
        lvCard.adapter = adapter

    }


}