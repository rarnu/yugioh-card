package com.rarnu.yugioh.card.adapter

import android.content.Context
import android.view.View
import com.rarnu.kt.android.BaseAdapter
import com.rarnu.yugioh.card.R
import kotlinx.android.synthetic.main.item_seasonlist.view.*

class SeasonAdapter(ctx: Context, list: MutableList<String>) : BaseAdapter<String, SeasonAdapter.SeasonHolder>(ctx, list) {

    override fun fillHolder(baseVew: View, holder: SeasonHolder, item: String, position: Int) {
        holder.tvSeasonName.text = item
    }

    override fun getAdapterLayout() = R.layout.item_seasonlist

    override fun getValueText(item: String) = ""

    override fun newHolder(baseView: View) = SeasonHolder(baseView)

    inner class SeasonHolder(v: View) {
        internal val tvSeasonName = v.tvSeasonName
    }
}