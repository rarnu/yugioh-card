package com.rarnu.yugioh.card

import android.app.Activity
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import com.rarnu.kt.android.DownloadState
import com.rarnu.kt.android.downloadAsync
import com.rarnu.kt.android.resStr
import com.rarnu.kt.android.showActionBack
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.YGORequest
import kotlinx.android.synthetic.main.activity_carddetail.*
import java.io.File
import kotlin.concurrent.thread

class CardDetailActivity : Activity() {

    private var hashid = ""
    private val MENUID_WIKI = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_carddetail)
        actionBar.title = intent.getStringExtra("name")
        showActionBack()
        hashid = intent.getStringExtra("hashid")

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

                if (ret.cardtype.contains("怪兽")) {
                    layMonRace.visibility = View.VISIBLE
                    layMonElement.visibility = View.VISIBLE
                    tvMonRaceValue.text = ret.race
                    tvMonElementValue.text = ret.element
                    if (ret.cardtype.contains("连接")) {
                        layMonAtk.visibility = View.VISIBLE
                        tvMonAtkValue.text = ret.atk
                        layMonLink.visibility = View.VISIBLE
                        layMonLinkArrow.visibility = View.VISIBLE
                        tvMonLinkValue.text = ret.link
                        tvMonLinkArrowValue.text = ret.linkarrow
                    } else {
                        layMonLevel.visibility = View.VISIBLE
                        if (ret.cardtype.contains("XYZ")) {
                            tvLevelTitle.text = resStr(R.string.tv_mon_rank)
                        } else {
                            tvLevelTitle.text = resStr(R.string.tv_mon_level)
                        }
                        tvMonLevelValue.text = ret.level
                        layMonAtk.visibility = View.VISIBLE
                        layMonDef.visibility = View.VISIBLE
                        tvMonAtkValue.text = ret.atk
                        tvMonDefValue.text = ret.def
                    }
                }

                tvEffectValue.text = ret.effect
                loadImage(ret.imageid)
                tvAdjustValue.text = ret.adjust
            }
        }

    }

    private fun loadImage(cardid: String) {
        val localImg = File(PathUtils.IMAGE_PATH, cardid).absolutePath
        if (File(localImg).exists()) {
            ivCardImg.setImageBitmap(BitmapFactory.decodeFile(localImg))
        } else {
            downloadAsync {
                url = String.format(YGORequest.RES_URL, cardid)
                localFile = localImg
                progress { state, _, _, _ ->
                    if (state == DownloadState.WHAT_DOWNLOAD_FINISH) {
                        if (File(localFile).exists()) {
                            runOnUiThread {
                                ivCardImg.setImageBitmap(BitmapFactory.decodeFile(localFile))
                            }
                        }
                    }
                }
            }
        }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val mWiki = menu.add(0, MENUID_WIKI, 1, R.string.menu_wiki)
        mWiki.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            android.R.id.home -> finish()
            MENUID_WIKI -> {
                val inWiki = Intent(this, CardWikiActivity::class.java)
                inWiki.putExtra("hashid", hashid)
                startActivity(inWiki)
            }
        }
        return true
    }
}