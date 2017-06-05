package com.yugioh.android.adapter

import android.content.Context
import android.view.View
import com.rarnu.base.app.BaseAdapter
import com.yugioh.android.R
import com.yugioh.android.classes.RightMenuItem
import kotlinx.android.synthetic.main.item_menu_right.view.*

class RightMenuAdapter(context: Context, list: MutableList<RightMenuItem>?) : BaseAdapter<RightMenuItem, RightMenuHolder>(context, list) {

    override fun fillHolder(baseVew: View, holder: RightMenuHolder, item: RightMenuItem) {
        holder.tvMenuName?.text = item.name
        when (item.type) {
            0 -> if (item.value == 0) {
                holder.ivImg?.setImageDrawable(null)
            } else {
                holder.ivImg?.setImageResource(android.R.drawable.ic_menu_upload)
            }
        }
    }

    override fun getAdapterLayout(): Int = R.layout.item_menu_right

    override fun newHolder(baseView: View): RightMenuHolder {
        val holder = RightMenuHolder()
        holder.tvMenuName = baseView.tvMenuName
        holder.ivImg = baseView.ivImg
        return holder
    }

    override fun getValueText(item: RightMenuItem): String? = ""
}
