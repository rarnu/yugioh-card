package com.yugioh.android.loader

import android.content.Context
import com.rarnu.base.app.BaseLoader
import com.rarnu.base.utils.FileUtils
import com.yugioh.android.classes.PackageItem
import com.yugioh.android.define.PathDefine
import com.yugioh.android.utils.YGOAPI

class PackageLoader(context: Context) : BaseLoader<PackageItem>(context) {

    var refresh = false

    override fun loadInBackground(): MutableList<PackageItem>? {
        var list: MutableList<PackageItem>?
        if (refresh) {
            refresh = false
            list = YGOAPI.packageList
            if (list != null && list.size != 0) {
                FileUtils.saveListToFile(list, PathDefine.PACK_LIST)
            } else {
                list = FileUtils.loadListFromFile(PathDefine.PACK_LIST) as MutableList<PackageItem>?
            }
        } else {
            list = FileUtils.loadListFromFile(PathDefine.PACK_LIST) as MutableList<PackageItem>?
            if (list == null) {
                list = YGOAPI.packageList
                if (list != null) {
                    FileUtils.saveListToFile(list, PathDefine.PACK_LIST)
                }
            }
        }
        return list
    }
}
