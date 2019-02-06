package com.rarnu.yugioh.card.adapter

import android.content.Context
import android.graphics.Color
import android.view.View
import com.rarnu.kt.android.BaseAdapter
import com.rarnu.kt.android.resStr
import com.rarnu.yugioh.LimitInfo
import com.rarnu.yugioh.card.R
import kotlinx.android.synthetic.main.item_limitlist.view.*

class LimitAdapter(ctx: Context, list: MutableList<LimitInfo>) : BaseAdapter<LimitInfo, LimitAdapter.LimitHolder>(ctx, list) {
    override fun fillHolder(baseVew: View, holder: LimitHolder, item: LimitInfo, position: Int) {
        holder.tvLimitType.setBackgroundColor(Color.parseColor(item.color))
        holder.tvLimitName.text = item.name
        when(item.limit) {
            0 -> {
                holder.tvLimitDesc.text = resStr(R.string.limit_0)
                holder.tvLimitDesc.setTextColor(Color.RED)
            }
            1 -> {
                holder.tvLimitDesc.text = resStr(R.string.limit_1)
                holder.tvLimitDesc.setTextColor(Color.parseColor("#FFA500"))
            }
            else -> {
                holder.tvLimitDesc.text = resStr(R.string.limit_2)
                holder.tvLimitDesc.setTextColor(Color.GREEN)
            }
        }
    }

    override fun getAdapterLayout() = R.layout.item_limitlist

    override fun getValueText(item: LimitInfo) = ""

    override fun newHolder(baseView: View) = LimitHolder(baseView)

    inner class LimitHolder(v: View) {
        internal val tvLimitType = v.tvLimitType
        internal val tvLimitName = v.tvLimitName
        internal val tvLimitDesc = v.tvLimitDesc
    }
}