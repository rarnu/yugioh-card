package com.rarnu.yugioh.card

import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.rarnu.android.BackActivity
import com.rarnu.android.runOnMainThread
import com.rarnu.yugioh.DeckTheme
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.card.adapter.SimpleDeckThemeAdapter
import kotlinx.android.synthetic.main.activity_deckincategory.*
import kotlin.concurrent.thread

class DeckInCategoryActivity: BackActivity() {

    private val listDeck = mutableListOf<DeckTheme>()
    private lateinit var adapter: SimpleDeckThemeAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_deckincategory)

        val hash = intent.getStringExtra("hash")

        adapter = SimpleDeckThemeAdapter(this, listDeck)
        gvDeck.adapter = adapter
        gvDeck.setOnItemClickListener { _, _, position, _ ->
            startActivity(Intent(this, DeckActivity::class.java).apply {
                putExtra("code", listDeck[position].code)
            })
        }

        thread {
            val data = YGOData.deckInCategory(hash)
            listDeck.clear()
            listDeck.addAll(data)
            runOnMainThread {
                adapter.setNewList(listDeck)
            }
        }

    }
}