package com.rarnu.yugioh.card

import android.app.Activity
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.Button
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

        btnMtNormal.setOnClickListener(this)
        btnMtEquip.setOnClickListener(this)
        btnMtQuick.setOnClickListener(this)
        btnMtCont.setOnClickListener(this)
        btnMtField.setOnClickListener(this)
        btnMtRitual.setOnClickListener(this)

        btnTtNormal.setOnClickListener(this)
        btnTtCont.setOnClickListener(this)
        btnTtCounter.setOnClickListener(this)

        btnMonEleLight.setOnClickListener(this)
        btnMonEleDark.setOnClickListener(this)
        btnMonEleFire.setOnClickListener(this)
        btnMonEleWater.setOnClickListener(this)
        btnMonEleEarth.setOnClickListener(this)
        btnMonEleWind.setOnClickListener(this)
        btnMonEleGod.setOnClickListener(this)

        btnMonCtNormal.setOnClickListener(this)
        btnMonCtEffect.setOnClickListener(this)
        btnMonCtRitual.setOnClickListener(this)
        btnMonCtFusion.setOnClickListener(this)
        btnMonCtSync.setOnClickListener(this)
        btnMonCtXyz.setOnClickListener(this)
        btnMonCtToon.setOnClickListener(this)
        btnMonCtUnion.setOnClickListener(this)
        btnMonCtSpirit.setOnClickListener(this)
        btnMonCtTuner.setOnClickListener(this)
        btnMonCtDouble.setOnClickListener(this)
        btnMonCtPendulum.setOnClickListener(this)
        btnMonCtReverse.setOnClickListener(this)
        btnMonCtSS.setOnClickListener(this)
        btnMonCtLink.setOnClickListener(this)

        btnMonRcWater.setOnClickListener(this)
        btnMonRcBeast.setOnClickListener(this)
        btnMonRcBW.setOnClickListener(this)
        btnMonRcCreation.setOnClickListener(this)
        btnMonRcDino.setOnClickListener(this)
        btnMonRcGod.setOnClickListener(this)
        btnMonRcDragon.setOnClickListener(this)

        btnMonRcAngel.setOnClickListener(this)
        btnMonRcDemon.setOnClickListener(this)
        btnMonRcFish.setOnClickListener(this)
        btnMonRcInsect.setOnClickListener(this)
        btnMonRcMachine.setOnClickListener(this)
        btnMonRcPlant.setOnClickListener(this)
        btnMonRcCy.setOnClickListener(this)

        btnMonRcFire.setOnClickListener(this)
        btnMonRcClaim.setOnClickListener(this)
        btnMonRcRock.setOnClickListener(this)
        btnMonRcSD.setOnClickListener(this)
        btnMonRcMagician.setOnClickListener(this)
        btnMonRcThunder.setOnClickListener(this)
        btnMonRcWarrior.setOnClickListener(this)

        btnMonRcWB.setOnClickListener(this)
        btnMonRcUndead.setOnClickListener(this)
        btnMonRcDD.setOnClickListener(this)
        btnMonRcCyber.setOnClickListener(this)

        btnLA1.setOnClickListener(this)
        btnLA2.setOnClickListener(this)
        btnLA3.setOnClickListener(this)
        btnLA4.setOnClickListener(this)
        btnLA6.setOnClickListener(this)
        btnLA7.setOnClickListener(this)
        btnLA8.setOnClickListener(this)
        btnLA9.setOnClickListener(this)

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
            else -> {
                val c = (v as Button).currentTextColor
                if (c == Color.BLACK) {
                    v.setTextColor(resColor(R.color.iostint))
                } else {
                    v.setTextColor(Color.BLACK)
                }
            }
        }
    }

    private fun isButtonSelected(btn: Button): Boolean {
        val color = btn.currentTextColor
        return color != Color.BLACK
    }

    private fun buildMonsterCardType(): String {
        var key = ""
        if (isButtonSelected(btnMonCtNormal)) { key += "通常," }
        if (isButtonSelected(btnMonCtEffect)) { key += "效果," }
        if (isButtonSelected(btnMonCtRitual)) { key += "仪式," }
        if (isButtonSelected(btnMonCtFusion)) { key += "融合," }
        if (isButtonSelected(btnMonCtSync)) { key += "同调," }
        if (isButtonSelected(btnMonCtXyz)) { key += "XYZ," }
        if (isButtonSelected(btnMonCtToon)) { key += "卡通," }
        if (isButtonSelected(btnMonCtUnion)) { key += "同盟," }
        if (isButtonSelected(btnMonCtSpirit)) { key += "灵魂," }
        if (isButtonSelected(btnMonCtTuner)) { key += "调整," }
        if (isButtonSelected(btnMonCtDouble)) { key += "二重," }
        if (isButtonSelected(btnMonCtPendulum)) { key += "灵摆," }
        if (isButtonSelected(btnMonCtReverse)) { key += "反转," }
        if (isButtonSelected(btnMonCtSS)) { key += "特殊召唤," }
        if (isButtonSelected(btnMonCtLink)) { key += "连接," }
        key = key.trimEnd(',')
        return key
    }

    private fun buildMonsterRace(): String {
        var key = ""
        if (isButtonSelected(btnMonRcWater)) { key += "水," }
        if (isButtonSelected(btnMonRcBeast)) { key += "兽," }
        if (isButtonSelected(btnMonRcBW)) { key += "兽战士," }
        if (isButtonSelected(btnMonRcCreation)) { key += "创造神," }
        if (isButtonSelected(btnMonRcDino)) { key += "恐龙," }
        if (isButtonSelected(btnMonRcGod)) { key += "幻神兽," }
        if (isButtonSelected(btnMonRcDragon)) { key += "龙," }

        if (isButtonSelected(btnMonRcAngel)) { key += "天使," }
        if (isButtonSelected(btnMonRcDemon)) { key += "恶魔," }
        if (isButtonSelected(btnMonRcFish)) { key += "鱼," }
        if (isButtonSelected(btnMonRcInsect)) { key += "昆虫," }
        if (isButtonSelected(btnMonRcMachine)) { key += "机械," }
        if (isButtonSelected(btnMonRcPlant)) { key += "植物," }
        if (isButtonSelected(btnMonRcCy)) { key += "念动力," }

        if (isButtonSelected(btnMonRcFire)) { key += "炎," }
        if (isButtonSelected(btnMonRcClaim)) { key += "爬虫类," }
        if (isButtonSelected(btnMonRcRock)) { key += "岩石," }
        if (isButtonSelected(btnMonRcSD)) { key += "海龙," }
        if (isButtonSelected(btnMonRcMagician)) { key += "魔法师," }
        if (isButtonSelected(btnMonRcThunder)) { key += "雷," }
        if (isButtonSelected(btnMonRcWarrior)) { key += "战士," }

        if (isButtonSelected(btnMonRcWB)) { key += "鸟兽," }
        if (isButtonSelected(btnMonRcUndead)) { key += "不死," }
        if (isButtonSelected(btnMonRcDD)) { key += "幻龙," }
        if (isButtonSelected(btnMonRcCyber)) { key += "电子界," }

        key = key.trimEnd(',')
        return key
    }

    private fun buildMonsterElement(): String {
        var key = ""
        if (isButtonSelected(btnMonEleLight)) { key += "光," }
        if (isButtonSelected(btnMonEleDark)) { key += "暗," }
        if (isButtonSelected(btnMonEleFire)) { key += "炎," }
        if (isButtonSelected(btnMonEleWater)) { key += "水," }
        if (isButtonSelected(btnMonEleEarth)) { key += "地," }
        if (isButtonSelected(btnMonEleWind)) { key += "风," }
        if (isButtonSelected(btnMonEleGod)) { key += "神," }
        key = key.trimEnd(',')
        return key
    }

    private fun buildMonsterLinkArrow(): String {
        var key = ""
        if (isButtonSelected(btnLA1)) { key += "1," }
        if (isButtonSelected(btnLA2)) { key += "2," }
        if (isButtonSelected(btnLA3)) { key += "3," }
        if (isButtonSelected(btnLA4)) { key += "4," }
        if (isButtonSelected(btnLA6)) { key += "6," }
        if (isButtonSelected(btnLA7)) { key += "7," }
        if (isButtonSelected(btnLA8)) { key += "8," }
        if (isButtonSelected(btnLA9)) { key += "9," }
        key = key.trimEnd(',')
        return key
    }

    private fun buildMagicCardType(): String {
        var key = ""
        if (isButtonSelected(btnMtNormal)) { key += "通常," }
        if (isButtonSelected(btnMtEquip)) { key += "装备," }
        if (isButtonSelected(btnMtQuick)) { key += "速攻," }
        if (isButtonSelected(btnMtCont)) { key += "永续," }
        if (isButtonSelected(btnMtField)) { key += "场地," }
        if (isButtonSelected(btnMtRitual)) { key += "仪式," }
        key = key.trimEnd(',')
        return key
    }

    private fun buildTrapCardType(): String {
        var key = ""
        if (isButtonSelected(btnTtNormal)) { key += "通常," }
        if (isButtonSelected(btnTtCont)) { key += "永续," }
        if (isButtonSelected(btnTtCounter)) { key += "反击," }
        key = key.trimEnd(',')
        return key
    }

    private fun doSearch() {
        // do search
        var key = " +(类:$cardtype)"
        val eff = edtEffect.text.toString()
        if (eff != "") key += " +(效果:$eff)"
        if (cardtype == "怪兽") {
            val atk = edtAtk.text.toString()
            if (atk != "") key += " +(atk:$atk)"
            val def = edtDef.text.toString()
            if (def != "") key += " +(def:$def)"
            val lvl = edtLevel.text.toString()
            if (lvl != "") key += " +(level:$lvl)"
            val scale = edtScale.text.toString()
            if (scale != "") key += " +(刻度:$scale)"
            val link = edtLink.text.toString()
            if (link != "") key += " +(link:$link)"
            val ct2 = buildMonsterCardType()
            if (ct2 != "") key += " +(类:$ct2)"
            val race = buildMonsterRace()
            if (race != "") key += " +(族:$race)"
            val ele = buildMonsterElement()
            if (ele != "") key += " +(属性:$ele)"
            val la = buildMonsterLinkArrow()
            if (la != "") key += " +(linkArrow:$la)"
        } else if (cardtype == "魔法") {
            val ct2 = buildMagicCardType()
            if (ct2 != "") key += " +(类:$ct2)"
        } else if (cardtype == "陷阱") {
            val ct2 = buildTrapCardType()
            if (ct2 != "") key += " +(类:$ct2)"
        }

        val inSearch = Intent(this, CardListActivity::class.java)
        inSearch.putExtra("key", key)
        startActivity(inSearch)
    }
}