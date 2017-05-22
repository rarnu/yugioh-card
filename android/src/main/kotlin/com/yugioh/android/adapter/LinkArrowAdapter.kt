package com.yugioh.android.adapter

import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.yugioh.android.R
import com.yugioh.android.base.BaseAdapter
import com.yugioh.android.classes.LinkArrowItem

/**
 * Created by rarnu on 5/22/17.
 */
class LinkArrowAdapter(context: Context, list: MutableList<LinkArrowItem>?) : BaseAdapter<LinkArrowItem>(context, list) {

    override fun getValueText(item: LinkArrowItem): String? = ""

    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View? {
        var v = convertView;
        if (v == null) {
            v = inflater.inflate(R.layout.item_grid_link, parent, false)
        }
        var holder = v?.tag as LinkArrowHolder?
        if (holder == null) {
            holder = LinkArrowHolder()
            holder.tvLinkArrow = v?.findViewById(R.id.tvLinkArrow) as TextView?
            v?.tag = holder
        }
        val item = list!![position]
        holder.tvLinkArrow?.text = item.title
        holder.tvLinkArrow?.setBackgroundResource(if (item.selected) R.drawable.bg_edittext_focused else R.drawable.bg_edittext_normal)
        return v
    }
}