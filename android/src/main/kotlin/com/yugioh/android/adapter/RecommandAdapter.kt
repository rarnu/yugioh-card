package com.yugioh.android.adapter

import android.content.Context
import android.view.View
import com.rarnu.base.app.BaseAdapter
import com.rarnu.base.utils.DownloadUtils
import com.yugioh.android.R
import com.yugioh.android.classes.RecommandInfo
import com.yugioh.android.define.NetworkDefine
import com.yugioh.android.define.PathDefine
import kotlinx.android.synthetic.main.item_recommand.view.*

class RecommandAdapter(context: Context, list: MutableList<RecommandInfo>?) : BaseAdapter<RecommandInfo, RecommandHolder>(context, list) {

    override fun fillHolder(baseVew: View, holder: RecommandHolder, item: RecommandInfo) {
        DownloadUtils.downloadFileT(context, holder.ivRecommand, NetworkDefine.RECOMMAND_IMAGE_URL + item.imagePath, PathDefine.RECOMMAND_PATH, item.imagePath, null)
    }

    override fun getAdapterLayout(): Int = R.layout.item_recommand

    override fun newHolder(baseView: View): RecommandHolder {
        val holder = RecommandHolder()
        holder.ivRecommand = baseView.ivRecommand
        return holder
    }

    override fun getValueText(item: RecommandInfo): String? = ""
}
