package com.yugioh.android.fragments

import android.os.Bundle
import android.view.Menu
import android.widget.TextView
import com.yugioh.android.R
import com.yugioh.android.base.BaseFragment
import com.yugioh.android.classes.CardInfo
import com.yugioh.android.common.Config
import com.yugioh.android.define.CardConstDefine
import com.yugioh.android.utils.ResourceUtils

class CardInfoCardFragment : BaseFragment() {

    internal var tvInfo: TextView? = null
    internal var info: CardInfo? = null
    internal var fontSize = -1

    init {
        tabTitle = ResourceUtils.getString(R.string.page_cardinfo)
    }

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun initComponents() {
        tvInfo = innerView?.findViewById(R.id.tvInfo) as TextView?
    }

    override fun initEvents() {
    }

    override fun initLogic() {
        info = activity.intent.getSerializableExtra("cardinfo") as CardInfo
        tvInfo?.text = buildCardInfo(info)

        fontSize = Config.cfgGetFontSize(activity)
        if (fontSize == -1) {
            fontSize = tvInfo!!.textSize.toInt()
        }
        tvInfo?.textSize = fontSize.toFloat()
    }

    private fun buildCardInfo(info: CardInfo?): String {
        if (info != null) {
            val sbInfo = StringBuilder()
            sbInfo.append(buildInfoLine(R.string.name, info.name))
            sbInfo.append(buildInfoLine(R.string.japan_name, info.japName))
            sbInfo.append(buildInfoLine(R.string.english_name, info.enName))
            sbInfo.append(buildInfoLine(R.string.type, info.sCardType))
            if (info.sCardType.contains(resources.getString(R.string.monster))) {
                sbInfo.append(buildInfoLine(R.string.split, ""))
                sbInfo.append(buildInfoLine(R.string.attribute, info.element))
                sbInfo.append(buildInfoLine(R.string.level, String.format("${info.level} %s", if (info.sCardType.contains(resources.getString(R.string.overlay))) resources.getString(R.string.lad) else "")))
                sbInfo.append(buildInfoLine(R.string.race, info.tribe))
                sbInfo.append(buildInfoLine(R.string.attack, info.atk))
                sbInfo.append(buildInfoLine(R.string.defense, info.def))
                if (info.cardDType.contains(getString(R.string.pendulum))) {
                    sbInfo.append(buildInfoLine(R.string.pendulum_level, getString(R.string.pendulum_LR, info.pendulumL, info.pendulumR)))
                }
                if (info.sCardType.contains(resources.getString(R.string.link))) {
                    sbInfo.append(buildInfoLine(R.string.link_count, "${info.link}"))
                    sbInfo.append(buildInfoLine(R.string.link_arrow, info.linkArrow
                            .replace("1", CardConstDefine.linkArrow[0])
                            .replace("2", CardConstDefine.linkArrow[1])
                            .replace("3", CardConstDefine.linkArrow[2])
                            .replace("4", CardConstDefine.linkArrow[3])
                            .replace("6", CardConstDefine.linkArrow[5])
                            .replace("7", CardConstDefine.linkArrow[6])
                            .replace("8", CardConstDefine.linkArrow[7])
                            .replace("9", CardConstDefine.linkArrow[8])
                    ))
                }
            }
            sbInfo.append(buildInfoLine(R.string.split, ""))
            sbInfo.append(buildInfoLine(R.string.limit, info.ban))
            sbInfo.append(buildInfoLine(R.string.pack, info.`package`))
            sbInfo.append(buildInfoLine(R.string.belongs, info.cardCamp))
            sbInfo.append(buildInfoLine(R.string.password, info.cheatcode))
            sbInfo.append(buildInfoLine(R.string.rare, info.infrequence))
            sbInfo.append(buildInfoLine(R.string.split, ""))
            sbInfo.append(buildInfoLine(R.string.effect, "\n" + info.effect.replace("======", getString(R.string.split))))
            return sbInfo.toString()
        } else {
            return ""
        }

    }

    private fun buildInfoLine(nameRes: Int, info: String?): String {
        var ret = resources.getString(nameRes)
        if (nameRes != R.string.split) {
            ret += ": " + info
        }
        ret += "\n"
        return ret
    }

    override fun getFragmentLayoutResId(): Int {
        return R.layout.fragment_cardinfo_card
    }

    override fun getMainActivityName(): String? {
        return ""
    }

    override fun initMenu(menu: Menu?) {

    }

    override fun onGetNewArguments(bn: Bundle?) {

    }

    override fun getCustomTitle(): String? {
        var title: String? = null
        if (info != null) {
            title = info?.name
        }
        return title
    }

    override fun getFragmentState(): Bundle? {
        return null
    }

}
