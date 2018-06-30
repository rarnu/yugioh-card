package com.rarnu.yugioh.card

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        btnFastSearch.setOnClickListener {
            val key = edtFastSearch.text.toString()
            if (key != "") {
                val inSearch = Intent(this, CardListActivity::class.java)
                inSearch.putExtra("key", key)
                startActivity(inSearch)
            }
        }
    }
}
