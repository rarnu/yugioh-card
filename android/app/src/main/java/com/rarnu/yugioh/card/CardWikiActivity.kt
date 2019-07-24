package com.rarnu.yugioh.card

import android.os.Bundle
import android.text.Html
import com.rarnu.android.BackActivity
import com.rarnu.android.resStr
import kotlinx.android.synthetic.main.activity_wiki.*

class CardWikiActivity : BackActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_wiki)
        actionBar?.title = resStr(R.string.card_wiki)
        tvWiki.text = Html.fromHtml(intent.getStringExtra("wiki"), 0)
    }

}