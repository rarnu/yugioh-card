package com.rarnu.yugioh.card

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.Gravity
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView
import com.rarnu.kt.android.dip2px
import com.rarnu.kt.android.showActionBack
import com.rarnu.yugioh.YGOData
import kotlinx.android.synthetic.main.activity_carddetail.*
import kotlin.concurrent.thread

class CardDetailActivity : Activity() {

    private var cardid = 0
    private var hashid = ""

    private val MENUID_IMAGE = 0
    private val MENUID_WIKI = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_carddetail)

        actionBar.title = intent.getStringExtra("name")
        showActionBack()

        hashid = intent.getStringExtra("hashid")
        cardid = intent.getIntExtra("cardid", 0)

        thread {
            val ret = YGOData.cardDetail(hashid)
            runOnUiThread {
                tvCardNameValue.text = ret.name
                tvCardJapNameValue.text = ret.japname
                tvCardEnNameValue.text = ret.enname
                tvCardTypeValue.text = ret.cardtype
                tvPasswordValue.text = ret.password
                tvLimitValue.text = ret.limit
                tvRareValue.text = ret.rare
                tvPackValue.text = ret.pack
                tvEffectValue.text = ret.effect

                for (p in ret.packs) {
                    val lbl = TextView(this)
                    lbl.gravity = Gravity.LEFT or Gravity.CENTER_VERTICAL
                    lbl.layoutParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 20.dip2px())
                    lbl.textSize = 11F
                    lbl.text = p.name
                    layPubPacks.addView(lbl)
                }

                if (ret.adjust == "") {
                    vAdjustLine.visibility = View.GONE
                    tvAdjustTitle.visibility = View.GONE
                    tvAdjustValue.visibility = View.GONE
                } else {
                    tvAdjustValue.text = ret.adjust
                }


            }
        }

    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val mImg = menu.add(0, MENUID_IMAGE, 0, R.string.menu_image)
        mImg.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
        val mWiki = menu.add(0, MENUID_WIKI, 1, R.string.menu_wiki)
        mWiki.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            android.R.id.home -> finish()
            MENUID_IMAGE -> {
                val inImage = Intent(this, CardImageActivity::class.java)
                inImage.putExtra("cardid", cardid)
                startActivity(inImage)
            }
            MENUID_WIKI -> {
                val inWiki = Intent(this, CardWikiActivity::class.java)
                inWiki.putExtra("hashid", hashid)
                startActivity(inWiki)
            }
        }
        return true
    }
}