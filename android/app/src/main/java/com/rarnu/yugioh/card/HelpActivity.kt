package com.rarnu.yugioh.card

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import com.rarnu.android.BackActivity
import com.rarnu.android.resStr
import kotlinx.android.synthetic.main.activity_help.*

class HelpActivity: BackActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_help)
        actionBar?.title = resStr(R.string.btn_help)

        tvGithub.setOnClickListener {
            startActivity(Intent(Intent.ACTION_VIEW).apply { data = Uri.parse("https://github.com/rarnu/yugioh-card") })
        }
    }
}