package com.yugioh.android.adapter

import android.app.Activity
import android.content.Context
import android.view.View
import com.rarnu.base.app.BaseAdapter
import com.rarnu.base.utils.DownloadUtils
import com.rarnu.base.utils.downloadAsync
import com.yugioh.android.R
import com.yugioh.android.classes.RecommandInfo
import com.yugioh.android.define.NetworkDefine
import com.yugioh.android.define.PathDefine
import kotlinx.android.synthetic.main.item_recommand.view.*

class RecommandAdapter(context: Context, list: MutableList<RecommandInfo>?) : BaseAdapter<RecommandInfo, RecommandHolder>(context, list) {

    override fun fillHolder(baseVew: View, holder: RecommandHolder, item: RecommandInfo) {
        downloadAsync(context as Activity) {
            imageView = holder.ivRecommand
            url = NetworkDefine.RECOMMAND_IMAGE_URL + item.imagePath
            localDir = PathDefine.RECOMMAND_PATH
            localFile = item.imagePath
        }
    }

    override fun getAdapterLayout(): Int = R.layout.item_recommand

    override fun newHolder(baseView: View): RecommandHolder {
        val holder = RecommandHolder()
        holder.ivRecommand = baseView.ivRecommand
        return holder
    }

    override fun getValueText(item: RecommandInfo): String? = ""
}
