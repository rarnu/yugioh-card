package com.rarnu.yugioh.card

import android.app.Activity
import android.graphics.Color
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import com.rarnu.kt.android.resColor
import com.rarnu.kt.android.resStr
import com.rarnu.kt.android.showActionBack
import kotlinx.android.synthetic.main.activity_search.*

class SearchActivity: Activity(), View.OnClickListener {

    private val MENUID_SEARCH = 1
    private var cardtype = "怪兽"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_search)
        actionBar.title = resStr(R.string.btn_adv_search)
        showActionBack()

        btnTypeMon.setTextColor(resColor(R.color.iostint))

        btnTypeMon.setOnClickListener(this)
        btnTypeMagic.setOnClickListener(this)
        btnTypeTrap.setOnClickListener(this)

    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val mSearch = menu.add(0, MENUID_SEARCH, 0, R.string.btn_search)
        mSearch.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when(item.itemId) {
            android.R.id.home -> finish()
            MENUID_SEARCH -> doSearch()
        }
        return true
    }

    override fun onClick(v: View) {
        when(v.id) {
            R.id.btnTypeMon -> {
                cardtype = "怪兽"
                btnTypeMon.setTextColor(resColor(R.color.iostint))
                btnTypeMagic.setTextColor(Color.BLACK)
                btnTypeTrap.setTextColor(Color.BLACK)
                layMonster.visibility = View.VISIBLE
                layMagic.visibility = View.GONE
                layTrap.visibility = View.GONE
            }
            R.id.btnTypeMagic -> {
                cardtype = "魔法"
                btnTypeMagic.setTextColor(resColor(R.color.iostint))
                btnTypeMon.setTextColor(Color.BLACK)
                btnTypeTrap.setTextColor(Color.BLACK)
                layMagic.visibility = View.VISIBLE
                layMonster.visibility = View.GONE
                layTrap.visibility = View.GONE
            }
            R.id.btnTypeTrap -> {
                cardtype = "陷阱"
                btnTypeTrap.setTextColor(resColor(R.color.iostint))
                btnTypeMon.setTextColor(Color.BLACK)
                btnTypeMagic.setTextColor(Color.BLACK)
                layTrap.visibility = View.VISIBLE
                layMagic.visibility = View.GONE
                layMonster.visibility = View.GONE
            }
        }
    }

    private fun doSearch() {
        // TODO: do search

    }
}