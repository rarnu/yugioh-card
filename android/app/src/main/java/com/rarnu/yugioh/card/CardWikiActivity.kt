package com.rarnu.yugioh.card

import android.app.Activity
import android.os.Bundle
import android.text.Html
import android.view.MenuItem
import com.rarnu.kt.android.resStr
import com.rarnu.kt.android.showActionBack
import kotlinx.android.synthetic.main.activity_wiki.*

class CardWikiActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_wiki)
        actionBar?.title = resStr(R.string.card_wiki)
        showActionBack()
        val wiki = intent.getStringExtra("wiki")
        tvWiki.text = Html.fromHtml(wiki, 0)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when(item.itemId) {
            android.R.id.home -> finish()
        }
        return true
    }
}