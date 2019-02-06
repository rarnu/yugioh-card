package com.rarnu.yugioh.card.adapter

import android.content.Context
import android.graphics.Color
import android.view.View
import com.rarnu.kt.android.BaseAdapter
import com.rarnu.kt.android.resColor
import com.rarnu.yugioh.card.R
import kotlinx.android.synthetic.main.item_seasonlist.view.*

class SeasonAdapter(ctx: Context, list: MutableList<String>) : BaseAdapter<String, SeasonAdapter.SeasonHolder>(ctx, list) {

    private var hightlight = 0

    fun setHighlight(h: Int) {
        hightlight = h
        notifyDataSetChanged()
    }

    override fun fillHolder(baseVew: View, holder: SeasonHolder, item: String, position: Int) {
        holder.tvSeasonName.text = item
        holder.tvSeasonName.setTextColor(if (hightlight == position) resColor(R.color.iostint) else Color.BLACK)
    }

    override fun getAdapterLayout() = R.layout.item_seasonlist

    override fun getValueText(item: String) = ""

    override fun newHolder(baseView: View) = SeasonHolder(baseView)

    inner class SeasonHolder(v: View) {
        internal val tvSeasonName = v.tvSeasonName
    }
}