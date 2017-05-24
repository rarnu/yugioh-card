package com.yugioh.android.adapter

import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import com.yugioh.android.R
import com.rarnu.base.app.BaseAdapter
import com.rarnu.base.utils.DownloadUtils
import com.yugioh.android.classes.RecommandInfo
import com.yugioh.android.define.NetworkDefine
import com.yugioh.android.define.PathDefine

class RecommandAdapter(context: Context, list: MutableList<RecommandInfo>?) : BaseAdapter<RecommandInfo>(context, list) {

    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View? {
        var v: View? = convertView
        if (v == null) {
            v = inflater.inflate(R.layout.item_recommand, parent, false)
        }
        var holder = v?.tag as RecommandHolder?
        if (holder == null) {
            holder = RecommandHolder()
            holder.ivRecommand = v?.findViewById(R.id.ivRecommand) as ImageView?
            v?.tag = holder
        }

        val item = list!![position]
        DownloadUtils.downloadFileT(context, holder.ivRecommand, NetworkDefine.RECOMMAND_IMAGE_URL + item.imagePath, PathDefine.RECOMMAND_PATH, item.imagePath, null)
        return v
    }

    override fun getValueText(item: RecommandInfo): String? {
        return ""
    }

}
