package com.rarnu.yugioh.card

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.media.ThumbnailUtils
import android.os.Bundle
import android.view.View
import com.rarnu.kt.android.resStr
import com.rarnu.kt.android.toast
import kotlinx.android.synthetic.main.activity_main.*
import kotlin.concurrent.thread

class MainActivity : Activity(), View.OnClickListener {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        btnSearch.setOnClickListener(this)
        btnAdvSearch.setOnClickListener(this)

        if (checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), 0)
        }
        /*
        thread {
            // val str = YGOData.searchCommon("影依", 1)
            // val str = YGOData.cardDetail("qPs8Xb")
            // val str = YGOData.limit()
            // val str = YGOData.packageList()
            // val str = YGOData.packageDetail("/package/CP18/wwSYE")
            // Log.e("YGO", "$str")
        }
        */
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?) {
        if (requestCode == 0) {
            if (grantResults != null) {
                if (grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                    finish()
                }
            }
        }
    }

    override fun onClick(v: View) {
        when(v.id) {
            R.id.btnSearch -> {
                val key = edtSearch.text.toString()
                if (key == "") {
                    toast(resStr(R.string.toast_empty_search_key))
                    return
                }
                val inSearch = Intent(this, CardListActivity::class.java)
                inSearch.putExtra("type", 0)
                inSearch.putExtra("key", key)
                startActivity(inSearch)
            }
            R.id.btnAdvSearch -> { }
        }
    }
}
