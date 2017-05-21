package com.yugioh.android.fragments

import android.app.AlertDialog
import android.content.DialogInterface
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.view.Menu
import android.view.View
import android.view.View.OnClickListener
import android.widget.*
import com.yugioh.android.R
import com.yugioh.android.base.BaseFragment
import com.yugioh.android.common.Config
import com.yugioh.android.define.NetworkDefine
import com.yugioh.android.define.PathDefine
import com.yugioh.android.utils.FileUtils

import java.io.File
import kotlin.concurrent.thread

class SettingsFragment : BaseFragment(), OnClickListener {

    internal var btnBigger: ImageView? = null
    internal var btnSmaller: ImageView? = null
    internal var tvFontDemo: TextView? = null
    internal var tvData: TextView? = null
    internal var btnSource: Button? = null

    internal var fontSize = -1

    override fun getBarTitle(): Int = R.string.settings

    override fun getBarTitleWithPath(): Int = R.string.settings

    override fun getCustomTitle(): String? = null

    override fun initComponents() {
        btnBigger = innerView?.findViewById(R.id.btnBigger) as ImageButton?
        btnSmaller = innerView?.findViewById(R.id.btnSmaller) as ImageButton?
        tvData = innerView?.findViewById(R.id.tvData) as TextView?
        tvFontDemo = innerView?.findViewById(R.id.tvFontDemo) as TextView?
        btnSource = innerView?.findViewById(R.id.btnSource) as Button?
    }

    override fun initEvents() {
        btnBigger?.setOnClickListener(this)
        btnSmaller?.setOnClickListener(this)
        tvData?.setOnClickListener(this)
        btnSource?.setOnClickListener(this)
    }

    override fun initLogic() {
        fontSize = Config.cfgGetFontSize(activity)
        if (fontSize == -1) {
            fontSize = tvFontDemo?.textSize!!.toInt()
        }
        tvFontDemo?.textSize = fontSize.toFloat()
        getDirSizeT()
    }

    private fun getDirSizeT() {
        val hSize = object : Handler() {
            override fun handleMessage(msg: Message) {
                if (msg.what == 1) {
                    tvData?.text = "${msg.obj as Long} MB"
                }
                super.handleMessage(msg)
            }
        }

        thread {
            var size: Long = FileUtils.getDirSize(PathDefine.ROOT_PATH)
            size /= (1024 * 1024).toLong()
            val msg = Message()
            msg.what = 1
            msg.obj = size
            hSize.sendMessage(msg)
        }
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_settings

    override fun getMainActivityName(): String? = ""

    override fun initMenu(menu: Menu?) {
    }

    override fun onGetNewArguments(bn: Bundle?) {
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.btnBigger -> fontSize++
            R.id.btnSmaller -> fontSize--
            R.id.tvData -> confirmDeleteImages()
            R.id.btnSource -> openSourceCodeSite()
        }
        tvFontDemo?.textSize = fontSize.toFloat()
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

    private val hDelete = object : Handler() {
        override fun handleMessage(msg: Message) {
            if (msg.what == 1) {
                getDirSizeT()
            }
            super.handleMessage(msg)
        }
    }

    private fun doDeleteImageT() {
        thread {
            val f = File(PathDefine.PICTURE_PATH)
            for (s in f.list()) {
                File(PathDefine.PICTURE_PATH + s).delete()
            }
            hDelete.sendEmptyMessage(1)
        }
    }

    override fun getFragmentState(): Bundle? = null

}
