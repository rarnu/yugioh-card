package com.rarnu.yugioh.card.adapter

import android.content.Context
import android.view.View
import com.rarnu.android.BaseAdapter
import com.rarnu.yugioh.PackageInfo
import com.rarnu.yugioh.card.R
import kotlinx.android.synthetic.main.item_packlist.view.*

class PackAdapter(ctx: Context, list: MutableList<PackageInfo>) : BaseAdapter<PackageInfo, PackAdapter.PackHolder>(ctx, list) {

    override fun fillHolder(baseVew: View, holder: PackHolder, item: PackageInfo, position: Int) {
        holder.tvPackName.text = item.name
    }

    override fun getAdapterLayout() = R.layout.item_packlist

    override fun getValueText(item: PackageInfo) = ""

    override fun newHolder(baseView: View) = PackHolder(baseView)

    inner class PackHolder(v: View) {
        internal val tvPackName = v.tvPackName
    }
}