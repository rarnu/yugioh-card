package com.rarnu.yugioh.card

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.MenuItem
import android.view.View
import com.rarnu.kt.android.resStr
import com.rarnu.kt.android.showActionBack
import kotlinx.android.synthetic.main.activity_help.*

class HelpActivity: Activity(), View.OnClickListener {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_help)
        actionBar.title = resStr(R.string.btn_help)
        showActionBack()
        // help
        tvOurocg.setOnClickListener(this)
        tvRarnu.setOnClickListener(this)
        tvThanks.setOnClickListener(this)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when(item.itemId) {
            android.R.id.home -> finish()
        }
        return true
    }

    override fun onClick(v: View) {
        when(v.id) {
            R.id.tvOurocg -> openUrl("https://www.ourocg.cn")
            R.id.tvRarnu -> openUrl("https://github.com/rarnu/yugioh-card")
            R.id.tvThanks -> {
                // TODO: thanks url
            }
        }
    }

    private fun openUrl(aurl: String) {
        val inWeb = Intent(Intent.ACTION_VIEW)
        inWeb.data = Uri.parse(aurl)
        startActivity(inWeb)
    }
}