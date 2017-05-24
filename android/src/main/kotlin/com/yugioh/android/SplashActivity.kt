package com.yugioh.android

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.KeyEvent
import com.rarnu.base.utils.ResourceUtils
import com.rarnu.base.utils.UIUtils

import java.util.Timer
import java.util.TimerTask

class SplashActivity : Activity() {

    private var tmr: Timer? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)
        UIUtils.initDisplayMetrics(this, windowManager, false)
        ResourceUtils.initResource(this)
        tmr = Timer()
        tmr!!.schedule(object : TimerTask() {
            override fun run() {
                tmr!!.cancel()
                startMainActivity()
                this@SplashActivity.finish()
            }
        }, 1500)
    }

    private fun startMainActivity() = startActivity(Intent(this, MainActivity::class.java))

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            return true
        }
        return super.onKeyDown(keyCode, event)
    }
}
