package com.yugioh.android.loader

import android.content.Context
import com.yugioh.android.base.BaseLoader
import com.yugioh.android.classes.DeckItem
import com.yugioh.android.utils.YGOAPI

class DeckLoader(context: Context) : BaseLoader<DeckItem>(context) {

    override fun loadInBackground(): MutableList<DeckItem>? = YGOAPI.deckList

}
