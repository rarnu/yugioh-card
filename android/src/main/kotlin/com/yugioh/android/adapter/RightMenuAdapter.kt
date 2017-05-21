package com.yugioh.android.adapter

import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import com.yugioh.android.R
import com.yugioh.android.base.BaseAdapter
import com.yugioh.android.classes.RightMenuItem

class RightMenuAdapter(context: Context, list: MutableList<RightMenuItem>?) : BaseAdapter<RightMenuItem>(context, list) {

    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View? {
        var v: View? = convertView
        if (v == null) {
            v = inflater.inflate(R.layout.item_menu_right, parent, false)
        }
        var holder = v?.tag as RightMenuHolder?
        if (holder == null) {
            holder = RightMenuHolder()
            holder.tvMenuName = v?.findViewById(R.id.tvMenuName) as TextView?
            holder.ivImg = v?.findViewById(R.id.ivImg) as ImageView?
            v?.tag = holder
        }

        val item = list!![position]
        holder.tvMenuName?.text = item.name
        when (item.type) {
            0 -> if (item.value == 0) {
                holder.ivImg?.setImageDrawable(null)
            } else {
                holder.ivImg?.setImageResource(android.R.drawable.ic_menu_upload)
            }
        }
        return v
    }

    override fun getValueText(item: RightMenuItem): String? = ""
}
