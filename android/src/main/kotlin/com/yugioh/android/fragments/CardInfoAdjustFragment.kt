package com.yugioh.android.fragments

import android.os.Bundle
import android.view.Menu
import android.view.View
import com.rarnu.base.app.BaseFragment
import com.rarnu.base.utils.ResourceUtils
import com.yugioh.android.R
import com.yugioh.android.classes.CardInfo
import com.yugioh.android.common.Config
import kotlinx.android.synthetic.main.fragment_cardinfo_adjust.view.*

class CardInfoAdjustFragment : BaseFragment() {

    private var info: CardInfo? = null
    private var fontSize = -1

    init {
        tabTitle = ResourceUtils.getString(R.string.page_cardadjust)
    }

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun initComponents() { }

    override fun initEvents() {
    }

    override fun initLogic() {
        info = activity.intent.getSerializableExtra("cardinfo") as CardInfo
        innerView.tvAdjust.text = info?.adjust
        innerView.tvNoAdjust.visibility = if (info?.adjust == null || info?.adjust?.trim { it <= ' ' } == "") View.VISIBLE else View.GONE
        fontSize = Config.cfgGetFontSize(activity)
        if (fontSize == -1) {
            fontSize = innerView.tvAdjust.textSize.toInt()
        }
        innerView.tvAdjust.textSize = fontSize.toFloat()
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_cardinfo_adjust

    override fun getMainActivityName(): String? = ""

    override fun initMenu(menu: Menu) { }

    override fun onGetNewArguments(bn: Bundle?) { }

    override fun getCustomTitle(): String? {
        var title: String? = null
        if (info != null) {
            title = info?.name
        }
        return title
    }

    override fun getFragmentState(): Bundle? = null

}
