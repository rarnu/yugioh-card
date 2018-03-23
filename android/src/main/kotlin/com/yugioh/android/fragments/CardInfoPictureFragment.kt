package com.yugioh.android.fragments

import android.graphics.BitmapFactory
import android.os.Bundle
import android.view.Menu
import android.view.View
import android.view.View.OnClickListener
import com.rarnu.base.app.BaseFragment
import com.rarnu.base.app.common.Actions
import com.rarnu.base.utils.ResourceUtils
import com.rarnu.base.utils.downloadAsync
import com.yugioh.android.R
import com.yugioh.android.classes.CardInfo
import com.yugioh.android.define.NetworkDefine
import com.yugioh.android.define.PathDefine
import kotlinx.android.synthetic.main.fragment_cardinfo_pic.view.*
import java.io.File

class CardInfoPictureFragment : BaseFragment(), OnClickListener {

    private var info: CardInfo? = null

    init {
        tabTitle = ResourceUtils.getString(R.string.page_picture)
    }

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun initComponents() {}

    override fun initEvents() {
        innerView.tvNoPic.setOnClickListener(this)
    }

    override fun initLogic() {
        info = activity.intent.getSerializableExtra("cardinfo") as CardInfo
        val picName = PathDefine.PICTURE_PATH + "${info?.id}.jpg"
        val fPic = File(picName)
        if (fPic.exists()) {
            val cardImg = BitmapFactory.decodeFile(picName)
            innerView.ivImage.setImageBitmap(cardImg)
            innerView.ivImage.visibility = View.VISIBLE
            innerView.tvNoPic.visibility = View.GONE
        } else {
            innerView.ivImage.visibility = View.GONE
            innerView.tvNoPic.visibility = View.VISIBLE
        }
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_cardinfo_pic

    override fun getMainActivityName(): String? = ""

    override fun initMenu(menu: Menu) {}

    override fun onGetNewArguments(bn: Bundle?) {}

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
        innerView.pbDownload.progress = 0
        innerView.pbDownload.visibility = View.VISIBLE
        innerView.tvNoPic.visibility = View.GONE
        val url = String.format(NetworkDefine.URL_CARD_IMAGE_FMT, info?.id)
        val localDir = PathDefine.PICTURE_PATH
        val localFile = "${info?.id}.jpg"
        downloadAsync(activity) {
            this.imageView = innerView.ivImage
            this.url = url
            this.localDir = localDir
            this.localFile = localFile
            progress { status, position, fileSize, _ ->
                activity.runOnUiThread {
                    when (status) {
                        Actions.WHAT_DOWNLOAD_START, Actions.WHAT_DOWNLOAD_PROGRESS -> {
                            innerView.pbDownload.max = fileSize
                            innerView.pbDownload.progress = position
                        }
                        Actions.WHAT_DOWNLOAD_FINISH -> {
                            innerView.pbDownload.visibility = View.GONE
                            innerView.ivImage.visibility = View.VISIBLE
                        }
                    }
                }

            }
        }
    }

    override fun getFragmentState(): Bundle? = null

}
