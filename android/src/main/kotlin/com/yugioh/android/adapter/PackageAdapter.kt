package com.yugioh.android.adapter


import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.AbsListView
import android.widget.TextView
import com.yugioh.android.R
import com.yugioh.android.base.BaseAdapter
import com.yugioh.android.classes.PackageItem
import com.yugioh.android.utils.DrawableUtils
import com.yugioh.android.utils.UIUtils

class PackageAdapter : BaseAdapter<PackageItem> {

    private var allpTitle: AbsListView.LayoutParams? = null
    private var allpList: AbsListView.LayoutParams? = null

    constructor(ctx: Context, list: MutableList<PackageItem>?) : super(ctx, list) {
        allpTitle = AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, UIUtils.dip2px(24))
        allpList = AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, UIUtils.dip2px(48))
    }

    override fun getValueText(item: PackageItem): String? = ""

    override fun isEnabled(position: Int): Boolean = !list!![position].isPackageTitle

    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View? {
        var v: View? = convertView
        if (v == null) {
            v = inflater.inflate(R.layout.item_package, parent, false)
        }
        var holder = v?.tag as PackageHolder?
        if (holder == null) {
            holder = PackageHolder()
            holder.tvPackName = v?.findViewById(R.id.tvPackName) as TextView?
            holder.tvLine = v?.findViewById(R.id.tvLine) as TextView?
            v?.tag = holder
        }
        val item = list!![position]
        holder.tvPackName?.text = item.name
        if (item.isPackageTitle) {
            holder.tvPackName?.setTextColor(context.resources.getColor(R.color.orange, context.theme))
        } else {
            holder.tvPackName?.setTextColor(DrawableUtils.getTextColorPrimary(context))
        }
        holder.tvPackName?.paint?.isFakeBoldText = item.isPackageTitle
        holder.tvLine?.visibility = if (item.isPackageTitle) View.VISIBLE else View.GONE
        v?.layoutParams = if (item.isPackageTitle) allpTitle else allpList
        return v
    }
}
