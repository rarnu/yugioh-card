package com.yugioh.android.adapter

import android.content.Context
import android.view.View
import com.rarnu.base.app.BaseAdapter
import com.yugioh.android.R
import com.yugioh.android.classes.DeckItem
import kotlinx.android.synthetic.main.item_deck.view.*

class DeckAdapter(context: Context, list: MutableList<DeckItem>?) : BaseAdapter<DeckItem, DeckHolder>(context, list) {

    override fun fillHolder(baseVew: View, holder: DeckHolder, item: DeckItem) {
        holder.tvDeckName?.text = item.name
        holder.tvDeckType?.text = item.type
    }

    override fun getAdapterLayout(): Int = R.layout.item_deck

    override fun newHolder(baseView: View): DeckHolder {
        val holder = DeckHolder()
        holder.tvDeckName = baseView.tvDeckName
        holder.tvDeckType = baseView.tvDeckType
        return holder
    }

    override fun getValueText(item: DeckItem): String? = item.name + item.type
}
