package com.yugioh.android

import android.app.AlertDialog
import android.app.Fragment
import android.os.Bundle
import android.view.KeyEvent
import android.view.MenuItem
import com.rarnu.base.app.BaseActivity
import com.rarnu.base.utils.DownloadUtils
import com.yugioh.android.fragments.UpdateFragment
import com.yugioh.android.intf.IUpdateIntf

class UpdateActivity : BaseActivity(), IUpdateIntf {

    internal var uf: UpdateFragment? = null
    private var inProgress = false
    private var localDir: String? = null
    private var localFile: String? = null

    override fun getActionBarCanBack(): Boolean = true

    override fun onCreate(savedInstanceState: Bundle?) {
        uf = UpdateFragment()
        super.onCreate(savedInstanceState)
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (inProgress) {
                confirmCloseUpdate()
                return true
            }
        }
        return super.onKeyDown(keyCode, event)
    }

    override fun onOptionsItemSelected(item: MenuItem?): Boolean {
        when (item?.itemId) {
            android.R.id.home -> if (inProgress) {
                confirmCloseUpdate()
                return true
            } else {
                finish()
            }
        }
        return super.onOptionsItemSelected(item)
    }

    private fun confirmCloseUpdate() {
        AlertDialog.Builder(this)
                .setTitle(R.string.hint)
                .setMessage(R.string.update_downloading)
                .setPositiveButton(R.string.ok) { _, _ ->
                    DownloadUtils.stopDownloadTask(localDir!!, localFile!!)
                    uf?.doDestroyHandler()
                    finish()
                }
                .setNegativeButton(R.string.cancel, null)
                .show()
    }

    override fun isInProgress(): Boolean = inProgress

    override fun setInProgress(inProgress: Boolean) {
        this.inProgress = inProgress
    }

    override fun getIcon(): Int = R.drawable.icon

    override fun replaceFragment(): Fragment = uf!!

    override fun customTheme(): Int = 0

    override fun setUpdateFile(localDir: String?, localFile: String?) {
        this.localDir = localDir
        this.localFile = localFile
    }

}
