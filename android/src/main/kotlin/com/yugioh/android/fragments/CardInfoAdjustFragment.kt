package com.yugioh.android.fragments

import android.os.Bundle
import android.view.Menu
import android.view.View
import android.widget.TextView
import com.yugioh.android.R
import com.rarnu.base.app.BaseFragment
import com.rarnu.base.utils.ResourceUtils
import com.yugioh.android.classes.CardInfo
import com.yugioh.android.common.Config

class CardInfoAdjustFragment : BaseFragment() {

    internal var info: CardInfo? = null
    internal var tvAdjust: TextView? = null
    internal var tvNoAdjust: TextView? = null
    internal var fontSize = -1

    init {
        tabTitle = ResourceUtils.getString(R.string.page_cardadjust)

    }

    override fun getBarTitle(): Int = 0


    override fun getBarTitleWithPath(): Int = 0


    override fun initComponents() {
        tvAdjust = innerView?.findViewById(R.id.tvAdjust) as TextView?
        tvNoAdjust = innerView?.findViewById(R.id.tvNoAdjust) as TextView?
    }

    override fun initEvents() {
    }

    override fun initLogic() {
        info = activity.intent.getSerializableExtra("cardinfo") as CardInfo
        tvAdjust?.text = info?.adjust
        tvNoAdjust?.visibility = if (info?.adjust == null || info?.adjust?.trim { it <= ' ' } == "") View.VISIBLE else View.GONE
        fontSize = Config.cfgGetFontSize(activity)
        if (fontSize == -1) {
            fontSize = tvAdjust?.textSize!!.toInt()
        }
        tvAdjust?.textSize = fontSize.toFloat()
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_cardinfo_adjust

    override fun getMainActivityName(): String? = ""

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

    override fun getFragmentState(): Bundle? = null

}
