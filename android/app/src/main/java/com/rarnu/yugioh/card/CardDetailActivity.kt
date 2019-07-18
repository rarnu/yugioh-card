package com.rarnu.yugioh.card

import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import com.rarnu.android.BackActivity
import com.rarnu.android.resStr
import com.rarnu.android.runOnMainThread
import com.rarnu.common.DownloadState
import com.rarnu.common.download
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.YGORequest
import kotlinx.android.synthetic.main.activity_carddetail.*
import java.io.File
import kotlin.concurrent.thread

class CardDetailActivity : BackActivity() {

    private var hashid = ""
    private var wikiForPass = ""
    private val MENUID_WIKI = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_carddetail)
        actionBar?.title = intent.getStringExtra("name")
        hashid = intent.getStringExtra("hashid")

        thread {
            val ret = YGOData.cardDetail(hashid)
            runOnMainThread {
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
                wikiForPass = ret.wiki
            }
        }

    }

    private fun loadImage(cardid: Int) {
        val localImg = File(PathUtils.IMAGE_PATH, cardid.toString()).absolutePath
        if (File(localImg).exists()) {
            ivCardImg.setImageBitmap(BitmapFactory.decodeFile(localImg))
        } else {
            thread {
                download {
                    url = String.format(YGORequest.RES_URL, cardid)
                    localFile = localImg
                    progress { state, _, _, _ ->
                        if (state == DownloadState.WHAT_DOWNLOAD_FINISH) {
                            if (File(localFile).exists()) {
                                runOnMainThread {
                                    ivCardImg.setImageBitmap(BitmapFactory.decodeFile(localFile))
                                }
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
            MENUID_WIKI -> {
                val inWiki = Intent(this, CardWikiActivity::class.java)
                inWiki.putExtra("wiki", wikiForPass)
                startActivity(inWiki)
            }
        }
        return super.onOptionsItemSelected(item)
    }
}