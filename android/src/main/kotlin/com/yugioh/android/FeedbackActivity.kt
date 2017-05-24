package com.yugioh.android

import android.Manifest
import android.app.Fragment
import android.content.pm.PackageManager
import android.os.Bundle
import com.rarnu.base.app.BaseActivity
import com.yugioh.android.fragments.FeedbackFragment

class FeedbackActivity : BaseActivity() {

    override fun getActionBarCanBack(): Boolean = true

    override fun getIcon(): Int = R.drawable.icon

    override fun replaceFragment(): Fragment = FeedbackFragment()

    override fun customTheme(): Int = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (checkSelfPermission(Manifest.permission.GET_ACCOUNTS) != PackageManager.PERMISSION_GRANTED || checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(arrayOf(Manifest.permission.GET_ACCOUNTS, Manifest.permission.READ_PHONE_STATE), 0)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?) {
        grantResults?.filter { it != PackageManager.PERMISSION_GRANTED }?.forEach { finish() }
    }
}

