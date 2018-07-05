package com.rarnu.yugioh.card

import android.app.Activity
import android.os.Bundle
import android.view.MenuItem
import com.rarnu.kt.android.showActionBack

class CardDetailActivity: Activity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_carddetail)

        actionBar.title = intent.getStringExtra("name")
        showActionBack()

        val hashid = intent.getStringExtra("hashid")

    }


    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when(item.itemId) {
            android.R.id.home -> finish()
        }
        return true
    }
}