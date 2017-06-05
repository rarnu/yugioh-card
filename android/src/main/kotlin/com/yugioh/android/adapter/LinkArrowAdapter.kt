package com.yugioh.android.adapter

import android.content.Context
import android.view.View
import com.rarnu.base.app.BaseAdapter
import com.yugioh.android.R
import com.yugioh.android.classes.LinkArrowItem
import kotlinx.android.synthetic.main.item_grid_link.view.*

/**
 * Created by rarnu on 5/22/17.
 */
class LinkArrowAdapter(context: Context, list: MutableList<LinkArrowItem>?) : BaseAdapter<LinkArrowItem, LinkArrowHolder>(context, list) {

    override fun fillHolder(baseVew: View, holder: LinkArrowHolder, item: LinkArrowItem) {
        holder.tvLinkArrow?.text = item.title
        holder.tvLinkArrow?.setBackgroundResource(if (item.selected) R.drawable.bg_edittext_focused else R.drawable.bg_edittext_normal)
    }

    override fun getAdapterLayout(): Int = R.layout.item_grid_link

    override fun newHolder(baseView: View): LinkArrowHolder {
        val holder = LinkArrowHolder()
        holder.tvLinkArrow = baseView.tvLinkArrow
        return holder
    }

    override fun getValueText(item: LinkArrowItem): String? = ""

}