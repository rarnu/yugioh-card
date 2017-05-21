package com.yugioh.android.fragments

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.view.Menu
import android.view.View
import android.view.View.OnClickListener
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import com.yugioh.android.R
import com.yugioh.android.base.BaseFragment
import com.yugioh.android.classes.CardInfo
import com.yugioh.android.common.Actions
import com.yugioh.android.define.NetworkDefine
import com.yugioh.android.define.PathDefine
import com.yugioh.android.utils.DownloadUtils
import com.yugioh.android.utils.ResourceUtils

import java.io.File

class CardInfoPictureFragment : BaseFragment(), OnClickListener {

    internal var info: CardInfo? = null
    internal var ivImage: ImageView? = null
    internal var tvNoPic: TextView? = null
    internal var pbDownload: ProgressBar? = null

    private val hDownloadProgress = object : Handler() {
        override fun handleMessage(msg: Message) {
            if (activity != null) {
                when (msg.what) {
                    Actions.WHAT_DOWNLOAD_START, Actions.WHAT_DOWNLOAD_PROGRESS -> {
                        pbDownload?.max = msg.arg2
                        pbDownload?.progress = msg.arg1
                    }
                    Actions.WHAT_DOWNLOAD_FINISH -> {
                        pbDownload?.visibility = View.GONE
                        ivImage?.visibility = View.VISIBLE
                    }
                }
            }
            super.handleMessage(msg)
        }
    }

    init {
        tabTitle = ResourceUtils.getString(R.string.page_picture)
    }

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun initComponents() {
        ivImage = innerView?.findViewById(R.id.ivImage) as ImageView?
        tvNoPic = innerView?.findViewById(R.id.tvNoPic) as TextView?
        pbDownload = innerView?.findViewById(R.id.pbDownload) as ProgressBar?
    }

    override fun initEvents() {
        tvNoPic?.setOnClickListener(this)
    }

    override fun initLogic() {
        info = activity.intent.getSerializableExtra("cardinfo") as CardInfo
        val picName = PathDefine.PICTURE_PATH + "${info?.id}.jpg"
        val fPic = File(picName)
        if (fPic.exists()) {
            val cardImg = BitmapFactory.decodeFile(picName)
            ivImage?.setImageBitmap(cardImg)
            ivImage?.visibility = View.VISIBLE
            tvNoPic?.visibility = View.GONE
        } else {
            ivImage?.visibility = View.GONE
            tvNoPic?.visibility = View.VISIBLE
        }
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_cardinfo_pic


    override fun getMainActivityName(): String? = ""


    override fun initMenu(menu: Menu?) {
    }

    override fun onGetNewArguments(bn: Bundle?) {
    }

    override fun getCustomTitle(): String? {
        var title: String? = null
        if (info != null) {
            title = info?.name
        }
        return title
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.tvNoPic -> doDownloadT()
        }
    }

    private fun doDownloadT() {
        pbDownload?.progress = 0
        pbDownload?.visibility = View.VISIBLE
        tvNoPic?.visibility = View.GONE
        val url = String.format(NetworkDefine.URL_CARD_IMAGE_FMT, info?.id)
        val localDir = PathDefine.PICTURE_PATH
        val localFile = "${info?.id}.jpg"
        DownloadUtils.downloadFileT(activity, ivImage, url, localDir, localFile, hDownloadProgress)
    }

    override fun getFragmentState(): Bundle? = null

}
