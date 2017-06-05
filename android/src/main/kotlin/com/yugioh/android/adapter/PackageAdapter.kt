package com.yugioh.android.adapter


import android.content.Context
import android.view.View
import android.widget.AbsListView
import com.rarnu.base.app.BaseAdapter
import com.rarnu.base.utils.DrawableUtils
import com.rarnu.base.utils.UIUtils
import com.yugioh.android.R
import com.yugioh.android.classes.PackageItem
import kotlinx.android.synthetic.main.item_package.view.*

class PackageAdapter : BaseAdapter<PackageItem, PackageHolder> {

    override fun fillHolder(baseVew: View, holder: PackageHolder, item: PackageItem) {
        holder.tvPackName?.text = item.name
        if (item.isPackageTitle) {
            holder.tvPackName?.setTextColor(context.resources.getColor(R.color.orange, context.theme))
        } else {
            holder.tvPackName?.setTextColor(DrawableUtils.getTextColorPrimary(context))
        }
        holder.tvPackName?.paint?.isFakeBoldText = item.isPackageTitle
        holder.tvLine?.visibility = if (item.isPackageTitle) View.VISIBLE else View.GONE

        baseVew.layoutParams = if (item.isPackageTitle) allpTitle else allpList
    }

    override fun getAdapterLayout(): Int = R.layout.item_package

    override fun newHolder(baseView: View): PackageHolder {
        val holder = PackageHolder()
        holder.tvPackName = baseView.tvPackName
        holder.tvLine = baseView.tvLine
        return holder
    }

    private var allpTitle: AbsListView.LayoutParams? = null
    private var allpList: AbsListView.LayoutParams? = null

    constructor(ctx: Context, list: MutableList<PackageItem>?) : super(ctx, list) {
        allpTitle = AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, UIUtils.dip2px(24))
        allpList = AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, UIUtils.dip2px(48))
    }

    override fun getValueText(item: PackageItem): String? = ""

    override fun isEnabled(position: Int): Boolean = !list!![position].isPackageTitle
}
