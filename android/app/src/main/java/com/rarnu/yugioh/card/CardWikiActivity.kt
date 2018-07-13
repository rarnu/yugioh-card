package com.rarnu.yugioh.card

import android.app.Activity
import android.os.Bundle
import android.util.Log
import android.view.MenuItem
import com.rarnu.kt.android.resStr
import com.rarnu.kt.android.showActionBack

class CardWikiActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_wiki)
        actionBar.title = resStr(R.string.card_wiki)
        showActionBack()

        // TODO: show wiki
        val wiki = intent.getStringExtra("wiki")
        Log.e("WIKI", wiki)

    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when(item.itemId) {
            android.R.id.home -> finish()
        }
        return true
    }
}