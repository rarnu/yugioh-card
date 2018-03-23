package com.yugioh.android.fragments

import android.app.AlertDialog
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.Menu
import android.view.View
import android.view.View.OnClickListener
import com.rarnu.base.app.BaseFragment
import com.rarnu.base.app.common.Actions
import com.rarnu.base.utils.FileUtils
import com.rarnu.base.utils.downloadAsync
import com.rarnu.base.utils.unzip
import com.yugioh.android.R
import com.yugioh.android.classes.UpdateInfo
import com.yugioh.android.database.YugiohDatabase
import com.yugioh.android.database.YugiohUtils
import com.yugioh.android.define.NetworkDefine
import com.yugioh.android.define.PathDefine
import com.yugioh.android.intf.IUpdateIntf
import com.yugioh.android.utils.UpdateUtils
import com.yugioh.android.utils.YGOAPI
import kotlinx.android.synthetic.main.fragment_update.view.*
import java.io.File
import kotlin.concurrent.thread

class UpdateFragment : BaseFragment(), OnClickListener {

    private val dbSource = PathDefine.DOWNLOAD_PATH + PathDefine.DATA_ZIP
    private val apkSource = PathDefine.DOWNLOAD_PATH + PathDefine.APK_NAME
    private var updateInfo: UpdateInfo? = null

    private var hasData = YugiohDatabase.isDatabaseFileExists

    override fun getBarTitle(): Int = R.string.page_update

    override fun getBarTitleWithPath(): Int = R.string.page_update

    override fun getCustomTitle(): String? = null

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_update

    override fun getMainActivityName(): String? = ""

    override fun initComponents() {}

    override fun initEvents() {
        innerView.btnUpdateApk.setOnClickListener(this)
        innerView.btnUpdateData.setOnClickListener(this)
    }

    override fun initLogic() {
        val fDownload = File(PathDefine.DOWNLOAD_PATH)
        if (!fDownload.exists()) {
            fDownload.mkdirs()
        }
        getUpdateLogT()
        UpdateUtils.checkUpdateT(activity) {
            activity.runOnUiThread { showUpdateInfo(it) }
        }
    }

    private fun getUpdateLogT() {
        thread {
            val ret = YGOAPI.updateLog
            activity.runOnUiThread {
                innerView.tvUpdateLogValue?.text = ret
            }
        }
    }

    private fun showUpdateInfo(info: UpdateInfo?) {
        updateInfo = info
        updateCurrentStatus()
        updateDisabled(true)
    }

    private fun updateCurrentStatus() {
        innerView.tvApkInfo.visibility = View.VISIBLE
        innerView.tvDataInfo.visibility = View.VISIBLE
        if (hasData) {
            when (updateInfo?.updateApk) {
                -1 -> {
                    innerView.tvApkInfo.text = getString(R.string.update_apk_fmt, updateInfo!!.apkVersion)
                    innerView.btnUpdateApk.setText(R.string.update_install)
                }
                0 -> {
                    innerView.tvApkInfo.setText(R.string.update_no_apk)
                    innerView.btnUpdateApk.setText(R.string.update_renew)
                }
                else -> {
                    innerView.tvApkInfo.text = getString(R.string.update_apk_fmt, updateInfo!!.apkVersion)
                    innerView.btnUpdateApk.setText(R.string.update_renew)
                }
            }
        }
        when (updateInfo?.updateData) {
            0 -> innerView.tvDataInfo.setText(R.string.update_no_data)
            else -> if (!hasData) {
                innerView.tvDataInfo.setText(R.string.update_data_full)
            } else {
                innerView.tvDataInfo.text = getString(R.string.update_data_fmt, updateInfo!!.newCard)
            }
        }

        if (!hasData) {
            innerView.layUpdateApk.visibility = View.GONE
            innerView.layNoDatabase.visibility = View.VISIBLE
        } else {
            innerView.layUpdateApk.visibility = View.VISIBLE
            innerView.layNoDatabase.visibility = View.GONE
        }

    }

    override fun initMenu(menu: Menu) {}

    override fun onGetNewArguments(bn: Bundle?) {}

    private fun unzipDataT() {
        thread {
            try {
                YugiohUtils.closeDatabase(activity)
                FileUtils.deleteFile(PathDefine.DATABASE_PATH)
                unzip {
                    zipPath = dbSource
                    destPath = PathDefine.ROOT_PATH
                    error { Log.e("UNZIP", "$it") }
                }
                FileUtils.deleteFile(dbSource)
                YugiohUtils.newDatabase(activity)
                activity.runOnUiThread {
                    innerView.pbDownlaodingData.visibility = View.GONE
                    (activity as IUpdateIntf).setInProgress(false)
                    updateInfo!!.updateData = 0
                    updateCurrentStatus()
                    updateDisabled(true)
                    confirmClose()
                }
            } catch (e: Exception) {

            }
        }
    }

    private fun confirmClose() {
        AlertDialog.Builder(activity)
                .setTitle(R.string.hint)
                .setMessage(R.string.update_download_data_finish)
                .setPositiveButton(R.string.ok) { _, _ ->
                    YugiohUtils.closeDatabase(activity)
                    YugiohUtils.newDatabase(activity)
                    activity.finish()
                    activity.sendBroadcast(Intent(com.yugioh.android.common.Actions.ACTION_CLOSE_MAIN))
                }
                .show()
    }

    private fun installApk() {
        val fApk = File(apkSource)
        if (fApk.exists()) {
            val uri = Uri.fromFile(fApk)
            val intent = Intent(Intent.ACTION_VIEW)
            intent.setDataAndType(uri, "application/vnd.android.package-archive")
            startActivity(intent)
        }
    }

    override fun onClick(v: View) {
        (activity as IUpdateIntf).setInProgress(true)
        updateDisabled(false)
        when (v.id) {
            R.id.btnUpdateApk -> if (updateInfo?.updateApk == -1) {
                installApk()
            } else {
                (activity as IUpdateIntf).setUpdateFile(PathDefine.DOWNLOAD_PATH, PathDefine.APK_NAME)
                innerView.tvApkInfo.visibility = View.GONE
                FileUtils.deleteFile(apkSource)
                innerView.pbDownlaodingApk.visibility = View.VISIBLE
                downloadAsync(activity) {
                    url = NetworkDefine.URL_APK
                    localDir = PathDefine.DOWNLOAD_PATH
                    localFile = PathDefine.APK_NAME
                    progress { status, position, fileSize, _ ->
                        activity.runOnUiThread {
                            when (status) {
                                Actions.WHAT_DOWNLOAD_START, Actions.WHAT_DOWNLOAD_PROGRESS -> {
                                    innerView.pbDownlaodingApk.max = fileSize
                                    innerView.pbDownlaodingApk.progress = position
                                }
                                Actions.WHAT_DOWNLOAD_FINISH -> try {
                                    innerView.pbDownlaodingApk.visibility = View.GONE
                                    (activity as IUpdateIntf).setInProgress(false)
                                    updateInfo?.updateApk = -1
                                    updateCurrentStatus()
                                    updateDisabled(true)
                                } catch (e: Exception) {

                                }

                            }
                        }
                    }
                }
            }
            R.id.btnUpdateData -> {
                (activity as IUpdateIntf).setUpdateFile(PathDefine.DOWNLOAD_PATH, PathDefine.DATA_ZIP)
                innerView.tvDataInfo.visibility = View.GONE
                FileUtils.deleteFile(dbSource)
                innerView.pbDownlaodingData.visibility = View.VISIBLE
                downloadAsync(activity) {
                    url = NetworkDefine.URL_DATA
                    localDir = PathDefine.DOWNLOAD_PATH
                    localFile = PathDefine.DATA_ZIP
                    progress { status, position, fileSize, _ ->
                        activity.runOnUiThread {
                            when (status) {
                                Actions.WHAT_DOWNLOAD_START, Actions.WHAT_DOWNLOAD_PROGRESS -> {
                                    innerView.pbDownlaodingData.max = fileSize
                                    innerView.pbDownlaodingData.progress = position
                                }
                                Actions.WHAT_DOWNLOAD_FINISH -> unzipDataT()
                            }
                        }
                    }
                }
            }
        }
    }

    private fun updateDisabled(enabled: Boolean) {
        innerView.btnUpdateApk.isEnabled = false
        innerView.btnUpdateData.isEnabled = false
        if (enabled) {

            if (updateInfo?.updateApk != 0) {
                innerView.btnUpdateApk.isEnabled = true
            }
            if (updateInfo?.updateData != 0) {
                innerView.btnUpdateData.isEnabled = true
            }
        }
    }

    override fun getFragmentState(): Bundle? = null

}
