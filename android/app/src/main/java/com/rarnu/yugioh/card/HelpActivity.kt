package com.rarnu.yugioh.card

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import com.rarnu.kt.android.BackActivity
import com.rarnu.kt.android.resStr
import kotlinx.android.synthetic.main.activity_help.*

class HelpActivity: BackActivity(), View.OnClickListener {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_help)
        actionBar?.title = resStr(R.string.btn_help)
        // help
        tvOurocg.setOnClickListener(this)
        tvRarnu.setOnClickListener(this)
        tvAuthor.setOnClickListener(this)
    }

    override fun onClick(v: View) {
        when(v.id) {
            R.id.tvOurocg -> openUrl("https://www.ourocg.cn")
            R.id.tvRarnu -> openUrl("https://github.com/rarnu/yugioh-card")
            R.id.tvAuthor -> openUrl("http://scarlett.vip/yugioh")
        }
    }

    private fun openUrl(aurl: String) {
        val inWeb = Intent(Intent.ACTION_VIEW)
        inWeb.data = Uri.parse(aurl)
        startActivity(inWeb)
    }
}