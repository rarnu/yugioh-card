package com.rarnu.yugioh.card

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.GridView
import com.rarnu.android.BackActivity
import com.rarnu.android.dip2px
import com.rarnu.android.runOnMainThread
import com.rarnu.yugioh.DeckCategory
import com.rarnu.yugioh.DeckTheme
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.card.adapter.SimpleDeckCategoryAdapter
import com.rarnu.yugioh.card.adapter.SimpleDeckThemeAdapter
import kotlinx.android.synthetic.main.activity_decklist.*
import kotlin.concurrent.thread

class DeckListActivity: BackActivity() {

    private val listCategory = mutableListOf<DeckCategory>()
    private val listTheme = mutableListOf<DeckTheme>()
    private lateinit var adapterCategory: SimpleDeckCategoryAdapter
    private lateinit var adapterTheme: SimpleDeckThemeAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_decklist)

        adapterCategory = SimpleDeckCategoryAdapter(this, listCategory)
        adapterTheme = SimpleDeckThemeAdapter(this, listTheme)
        gvCategory.adapter = adapterCategory
        gvTheme.adapter = adapterTheme

        gvCategory.setOnItemClickListener { _, _, position, _ ->
            startActivity(Intent(this, DeckInCategoryActivity::class.java).apply {
                putExtra("hash", listCategory[position].guid)
            })
        }

        gvTheme.setOnItemClickListener { _, _, position, _ ->
            startActivity(Intent(this, DeckActivity::class.java).apply {
                putExtra("code", listTheme[position].code)
            })
        }

        thread {
            val c = YGOData.deckCategory()
            listCategory.clear()
            listCategory.addAll(c)
            val t = YGOData.deckTheme()
            listTheme.clear()
            listTheme.addAll(t)
            runOnMainThread {
                adapterCategory.setNewList(listCategory)
                adapterTheme.setNewList(listTheme)
                resetGridHeight(gvCategory, listCategory)
                resetGridHeight(gvTheme, listTheme)
            }
        }
    }

    private fun resetGridHeight(g: GridView, list: List<*>) {
        var line = list.size / 3
        if (list.size % 3 != 0) {
            line++
        }
        val lay = g.layoutParams
        lay.height = (line * 41).dip2px()
        g.layoutParams = lay
    }

}