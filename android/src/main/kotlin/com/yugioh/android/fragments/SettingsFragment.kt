package com.yugioh.android.fragments

import android.app.AlertDialog
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.Menu
import android.view.View
import android.view.View.OnClickListener
import com.rarnu.base.app.BaseFragment
import com.rarnu.base.utils.FileUtils
import com.yugioh.android.R
import com.yugioh.android.common.Config
import com.yugioh.android.define.NetworkDefine
import com.yugioh.android.define.PathDefine
import kotlinx.android.synthetic.main.fragment_settings.view.*
import java.io.File
import kotlin.concurrent.thread

class SettingsFragment : BaseFragment(), OnClickListener {

    private var fontSize = -1

    override fun getBarTitle(): Int = R.string.settings

    override fun getBarTitleWithPath(): Int = R.string.settings

    override fun getCustomTitle(): String? = null

    override fun initComponents() {}

    override fun initEvents() {
        innerView.btnBigger.setOnClickListener(this)
        innerView.btnSmaller.setOnClickListener(this)
        innerView.tvData.setOnClickListener(this)
        innerView.btnSource.setOnClickListener(this)
    }

    override fun initLogic() {
        fontSize = Config.cfgGetFontSize(activity)
        if (fontSize == -1) {
            fontSize = innerView.tvFontDemo.textSize.toInt()
        }
        innerView.tvFontDemo.textSize = fontSize.toFloat()
        getDirSizeT()
    }

    private fun getDirSizeT() {
        thread {
            var size: Long = FileUtils.getDirSize(PathDefine.ROOT_PATH)
            size /= (1024 * 1024).toLong()
            activity.runOnUiThread {
                innerView.tvData.text = "$size MB"
            }
        }
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_settings

    override fun getMainActivityName(): String? = ""

    override fun initMenu(menu: Menu) {}

    override fun onGetNewArguments(bn: Bundle?) {}

    override fun onClick(v: View) {
        when (v.id) {
            R.id.btnBigger -> fontSize++
            R.id.btnSmaller -> fontSize--
            R.id.tvData -> confirmDeleteImages()
            R.id.btnSource -> openSourceCodeSite()
        }
        innerView.tvFontDemo.textSize = fontSize.toFloat()
        Config.cfgSetFontSize(activity, fontSize)
    }

    private fun openSourceCodeSite() {
        val inSite = Intent(Intent.ACTION_VIEW)
        inSite.data = Uri.parse(NetworkDefine.URL_GITHUB)
        startActivity(inSite)
    }

    private fun confirmDeleteImages() {
        AlertDialog.Builder(activity).setTitle(R.string.hint).setMessage(R.string.str_confirm_delete)
                .setPositiveButton(R.string.ok) { _, _ -> doDeleteImageT() }
                .setNegativeButton(R.string.cancel, null)
                .show()
    }

    private fun doDeleteImageT() {
        thread {
            val f = File(PathDefine.PICTURE_PATH)
            for (s in f.list()) {
                File(PathDefine.PICTURE_PATH + s).delete()
            }
            activity.runOnUiThread {
                getDirSizeT()
            }
        }
    }

    override fun getFragmentState(): Bundle? = null

}
