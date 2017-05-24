package com.yugioh.android.fragments

import android.content.pm.PackageManager
import android.os.Bundle
import android.view.Menu
import android.widget.TextView
import com.yugioh.android.R
import com.rarnu.base.app.BaseDialogFragment
import com.rarnu.base.utils.DeviceUtils

class AboutFragment : BaseDialogFragment() {

    internal var tvVersion: TextView? = null
    internal var tvAboutDate: TextView? = null

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_about


    override fun initComponents() {
        tvVersion = innerView?.findViewById(R.id.tvVersion) as TextView?
        tvAboutDate = innerView?.findViewById(R.id.tvAboutDate) as TextView?
    }

    override fun initEvents() {
    }

    override fun initLogic() {
        tvVersion?.text = DeviceUtils.getAppVersionName(activity)
        var releaseDate = ""
        try {
            val appInfo = activity.packageManager.getApplicationInfo(activity.packageName, PackageManager.GET_META_DATA)
            releaseDate = appInfo.metaData.getString("release-date")

        } catch (e: Exception) {
        }
        tvAboutDate?.text = getString(R.string.about_date_fmt, releaseDate)
    }

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun getCustomTitle(): String? = null

    override fun getMainActivityName(): String? = null

    override fun initMenu(menu: Menu?) {
    }

    override fun onGetNewArguments(bn: Bundle?) {
    }

    override fun getFragmentState(): Bundle? = null

}
