package com.rarnu.yugioh.card.adapter

import android.app.Activity
import android.content.Context
import android.graphics.BitmapFactory
import android.util.Log
import android.view.View
import com.rarnu.android.BaseAdapter
import com.rarnu.common.DownloadState
import com.rarnu.common.download
import com.rarnu.yugioh.CardInfo
import com.rarnu.yugioh.YGORequest
import com.rarnu.yugioh.card.PathUtils
import com.rarnu.yugioh.card.R
import kotlinx.android.synthetic.main.item_cardlist.view.*
import java.io.File
import kotlin.concurrent.thread

class CardListAdapter(ctx: Context, list: MutableList<CardInfo>) : BaseAdapter<CardInfo, CardListAdapter.CardListHolder>(ctx, list) {

    override fun fillHolder(baseVew: View, holder: CardListHolder, item: CardInfo, position: Int) {
        Log.e("CardListAdapter", "name => ${item.name}, jpname => ${item.japname}")
        holder.tvCardName.text = resStr(R.string.item_name, item.name)
        holder.tvCardJapName.text = resStr(R.string.item_japname, item.japname)
        holder.tvCardEnName.text = resStr(R.string.item_enname, item.enname)
        holder.tvCardType.text = item.cardtype

        val localImg = File(PathUtils.IMAGE_PATH, item.cardid.toString()).absolutePath
        if (File(localImg).exists()) {
            holder.ivCardImg.setImageBitmap(BitmapFactory.decodeFile(localImg))
        } else {
            thread {
                download {
                    url = String.format(YGORequest.RES_URL, item.cardid)
                    localFile = localImg
                    progress { state, _, _, _ ->
                        if (state == DownloadState.WHAT_DOWNLOAD_FINISH) {
                            if (File(localFile).exists()) {
                                (context as Activity).runOnUiThread {
                                    holder.ivCardImg.setImageBitmap(BitmapFactory.decodeFile(localFile))
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    override fun getAdapterLayout() = R.layout.item_cardlist

    override fun getValueText(item: CardInfo) = ""

    override fun newHolder(baseView: View) = CardListHolder(baseView)

    inner class CardListHolder(v: View) {
        internal val tvCardName = v.tvCardName
        internal val tvCardJapName = v.tvCardJapName
        internal val tvCardEnName = v.tvCardEnName
        internal val tvCardType = v.tvCardType
        internal val ivCardImg = v.ivCardImg
    }
}