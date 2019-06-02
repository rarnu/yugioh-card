package com.rarnu.yugioh.card.adapter

import android.content.Context
import android.view.View
import com.rarnu.android.BaseAdapter
import com.rarnu.yugioh.HotCard
import com.rarnu.yugioh.HotPack
import com.rarnu.yugioh.card.R
import kotlinx.android.synthetic.main.item_simple.view.*

class SimpleSearchAdapter(ctx: Context, list: MutableList<String>) : BaseAdapter<String, SimpleSearchAdapter.SearchHolder>(ctx, list) {
    override fun fillHolder(baseVew: View, holder: SearchHolder, item: String, position: Int) {
        holder.tvName.text = item
    }

    override fun getAdapterLayout() = R.layout.item_simple

    override fun getValueText(item: String) = ""

    override fun newHolder(baseView: View) = SearchHolder(baseView)

    inner class SearchHolder(v: View) {
        internal val tvName = v.tvName
    }


}

class SimpleCardAdapter(ctx: Context, list: MutableList<HotCard>) : BaseAdapter<HotCard, SimpleCardAdapter.HotCardHolder>(ctx, list) {

    override fun fillHolder(baseVew: View, holder: HotCardHolder, item: HotCard, position: Int) {
        holder.tvName.text = item.name
    }

    override fun getAdapterLayout() = R.layout.item_simple

    override fun getValueText(item: HotCard) = ""

    override fun newHolder(baseView: View) = HotCardHolder(baseView)

    inner class HotCardHolder(v: View) {
        internal val tvName = v.tvName
    }
}

class SimplePackAdapter(ctx: Context, list: MutableList<HotPack>) : BaseAdapter<HotPack, SimplePackAdapter.HotPackHolder>(ctx, list) {
    override fun fillHolder(baseVew: View, holder: HotPackHolder, item: HotPack, position: Int) {
        holder.tvName.text = item.name
    }

    override fun getAdapterLayout() = R.layout.item_simple

    override fun getValueText(item: HotPack) = ""

    override fun newHolder(baseView: View) = HotPackHolder(baseView)
    inner class HotPackHolder(v: View) {
        internal val tvName = v.tvName

        init {
            tvName.textSize = 12F
        }
    }
}