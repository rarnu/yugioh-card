package com.rarnu.yugioh.card

import android.app.Activity
import android.os.Bundle
import android.view.MenuItem
import com.rarnu.kt.android.resStr
import com.rarnu.kt.android.showActionBack

class HelpActivity: Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_help)
        actionBar.title = resStr(R.string.btn_help)
        showActionBack()

        // TODO: help
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when(item.itemId) {
            android.R.id.home -> finish()
        }
        return true
    }
}