package com.yugioh.android.fragments

import android.content.pm.PackageManager
import android.os.Bundle
import android.view.Menu
import com.rarnu.base.app.BaseDialogFragment
import com.rarnu.base.utils.DeviceUtils
import com.yugioh.android.R
import kotlinx.android.synthetic.main.fragment_about.view.*

class AboutFragment : BaseDialogFragment() {

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_about

    override fun initComponents() { }

    override fun initEvents() { }

    override fun initLogic() {
        innerView.tvVersion.text = DeviceUtils.getAppVersionName(activity)
        var releaseDate = ""
        try {
            val appInfo = activity.packageManager.getApplicationInfo(activity.packageName, PackageManager.GET_META_DATA)
            releaseDate = appInfo.metaData.getString("release-date")

        } catch (e: Exception) {
        }
        innerView.tvAboutDate.text = getString(R.string.about_date_fmt, releaseDate)
    }

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun getCustomTitle(): String? = null

    override fun getMainActivityName(): String? = null

    override fun initMenu(menu: Menu) { }

    override fun onGetNewArguments(bn: Bundle?) { }

    override fun getFragmentState(): Bundle? = null

}
