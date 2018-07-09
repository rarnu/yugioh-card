package com.rarnu.yugioh.card

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.media.ThumbnailUtils
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import com.rarnu.kt.android.initUI
import com.rarnu.kt.android.resStr
import com.rarnu.kt.android.toast
import kotlinx.android.synthetic.main.activity_main.*
import kotlin.concurrent.thread

class MainActivity : Activity(), View.OnClickListener {

    private val MENUID_LIMIT = 0
    private val MENUID_PACK = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        initUI()
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        btnSearch.setOnClickListener(this)
        btnAdvSearch.setOnClickListener(this)

        if (checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), 0)
        }
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
            R.id.btnAdvSearch -> {
                // TODO: adv search
            }
        }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val mLimit = menu.add(0, MENUID_LIMIT, 0, R.string.card_limit)
        mLimit.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
        val mPack = menu.add(0, MENUID_PACK, 1, R.string.card_pack)
        mPack.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when(item.itemId) {
            MENUID_LIMIT -> startActivity(Intent(this, LimitActivity::class.java))
            MENUID_PACK -> {
                // TODO: pack
            }
        }
        return true
    }
}
