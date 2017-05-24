package com.yugioh.android.adapter

import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.yugioh.android.R
import com.rarnu.base.app.BaseAdapter
import com.yugioh.android.classes.DeckItem

class DeckAdapter(context: Context, list: MutableList<DeckItem>?) : BaseAdapter<DeckItem>(context, list) {

    override fun getValueText(item: DeckItem): String? = item.name + item.type

    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View? {
        var v: View? = convertView
        if (v == null) {
            v = inflater.inflate(R.layout.item_deck, parent, false)
        }
        var holder = v?.tag as DeckHolder?
        if (holder == null) {
            holder = DeckHolder()
            holder.tvDeckName = v?.findViewById(R.id.tvDeckName) as TextView?
            holder.tvDeckType = v?.findViewById(R.id.tvDeckType) as TextView?
            v?.tag = holder
        }
        val item = list!![position]
        holder.tvDeckName?.text = item.name
        holder.tvDeckType?.text = item.type
        return v
    }
}
