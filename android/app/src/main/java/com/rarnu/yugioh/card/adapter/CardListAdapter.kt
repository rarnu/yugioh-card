package com.rarnu.yugioh.card.adapter

import android.content.Context
import android.view.View
import com.rarnu.kt.android.BaseAdapter
import com.rarnu.yugioh.card.R
import com.rarnu.yugioh.card.data.CardListInfo
import kotlinx.android.synthetic.main.item_cardlist.view.*

class CardListAdapter(ctx: Context, list: MutableList<CardListInfo>) : BaseAdapter<CardListInfo, CardListAdapter.CardListHolder>(ctx, list) {

    override fun fillHolder(baseVew: View, holder: CardListHolder, item: CardListInfo, position: Int) {
        holder.tvCardName.text = item.name
        holder.tvCardType.text = item.cardtype
    }

    override fun getAdapterLayout() = R.layout.item_cardlist

    override fun getValueText(item: CardListInfo) = ""

    override fun newHolder(baseView: View) = CardListHolder(baseView)

    inner class CardListHolder(v: View) {
        internal val tvCardName = v.tvCardName
        internal val tvCardType = v.tvCardType
        internal val imgCardImage = v.imgCardImage
    }

}