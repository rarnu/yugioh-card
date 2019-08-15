package com.rarnu.yugioh.card

import android.os.Bundle
import android.util.Log
import com.rarnu.android.BackActivity

class DeckActivity: BackActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_deckdetail)
        val code = intent.getStringExtra("code")

        Log.e("YGO", "code => $code")
        // TODO: deck
    }

}