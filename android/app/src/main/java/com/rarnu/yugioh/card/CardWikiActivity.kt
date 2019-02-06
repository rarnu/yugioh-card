package com.rarnu.yugioh.card

import android.os.Bundle
import android.text.Html
import com.rarnu.kt.android.BackActivity
import com.rarnu.kt.android.resStr
import kotlinx.android.synthetic.main.activity_wiki.*

class CardWikiActivity : BackActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_wiki)
        actionBar?.title = resStr(R.string.card_wiki)
        val wiki = intent.getStringExtra("wiki")
        tvWiki.text = Html.fromHtml(wiki, 0)
    }

}