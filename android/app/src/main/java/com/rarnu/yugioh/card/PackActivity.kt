package com.rarnu.yugioh.card

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import com.rarnu.android.BackActivity
import com.rarnu.android.resStr
import com.rarnu.android.runOnMainThread
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
            runOnMainThread {
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
                runOnMainThread {
                    adapterPack.setNewList(listPack)
                    adapterSeason.setHighlight(position)
                }
            }
        } else {
            startActivity(Intent(this, PackDetailActivity::class.java).apply {
                putExtra("url", listPack[position].url)
                putExtra("name", listPack[position].abbr)
            })
        }
    }
}

