package com.yugioh.android.intf

interface IUpdateIntf {

    fun setUpdateFile(localDir: String?, localFile: String?)

    fun isInProgress(): Boolean

    fun setInProgress(inProgress: Boolean)

}
