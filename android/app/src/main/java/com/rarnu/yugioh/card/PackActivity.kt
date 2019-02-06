package com.rarnu.yugioh.card

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.MenuItem
import android.view.View
import android.widget.AdapterView
import com.rarnu.kt.android.BackActivity
import com.rarnu.kt.android.resStr
import com.rarnu.kt.android.showActionBack
import com.rarnu.yugioh.PackageInfo
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.card.adapter.PackAdapter
import com.rarnu.yugioh.card.adapter.SeasonAdapter
import kotlinx.android.synthetic.main.activity_pack.*
import kotlin.concurrent.thread

class PackActivity: BackActivity(), AdapterView.OnItemClickListener {


    private val listSeason = arrayListOf<String>()
    private val listPack = arrayListOf<PackageInfo>()
    private val listOrigin = arrayListOf<PackageInfo>()

    private lateinit var adapterSeason: SeasonAdapter
    private lateinit var adapterPack: PackAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_pack)
        actionBar?.title = resStr(R.string.card_pack)

        adapterSeason = SeasonAdapter(this, listSeason)
        lvSeason.adapter = adapterSeason
        adapterPack = PackAdapter(this, listPack)
        lvPack.adapter = adapterPack

        lvSeason.onItemClickListener = this
        lvPack.onItemClickListener = this

        thread {
            val tmp = YGOData.packageList()
            listOrigin.clear()
            listOrigin.addAll(tmp)
            listSeason.clear()
            listPack.clear()
            var lastSeason = ""
            for (p in listOrigin) {
                if (lastSeason == "") {
                    lastSeason = p.season
                }
                if (listSeason.indexOf(p.season) == -1) {
                    listSeason.add(p.season)
                }
                if (p.season == lastSeason) {
                    listPack.add(p)
                }
            }
            runOnUiThread {
                adapterSeason.setNewList(listSeason)
                adapterPack.setNewList(listPack)
            }
        }
    }

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        if (parent == lvSeason) {
            val season = listSeason[position]
            thread {
                listPack.clear()
                for (p in listOrigin) {
                    if (p.season == season) {
                        listPack.add(p)
                    }
                }
                runOnUiThread {
                    adapterPack.setNewList(listPack)
                    adapterSeason.setHighlight(position)
                }
            }
        } else {
            val pack = listPack[position]
            val inDetail = Intent(this, PackDetailActivity::class.java)
            inDetail.putExtra("url", pack.url)
            inDetail.putExtra("name", pack.abbr)
            startActivity(inDetail)
        }
    }
}

