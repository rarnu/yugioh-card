package com.yugioh.android.fragments

import android.content.Intent
import android.content.Loader
import android.net.Uri
import android.os.Bundle
import android.view.Menu
import android.view.View
import com.rarnu.base.app.BaseFragment
import com.rarnu.base.utils.ResourceUtils
import com.yugioh.android.R
import com.yugioh.android.classes.CardInfo
import com.yugioh.android.define.NetworkDefine
import com.yugioh.android.loader.WikiLoader
import kotlinx.android.synthetic.main.fragment_cardinfo_wiki.view.*

/**
 * Created by rarnu on 5/29/17.
 */
class CardInfoWikiFragment : BaseFragment(), View.OnClickListener, Loader.OnLoadCompleteListener<String> {

    private var info: CardInfo? = null
    internal var loader: WikiLoader? = null

    init {
        tabTitle = ResourceUtils.getString(R.string.page_wiki)
    }

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun getCustomTitle(): String? {
        var title: String? = null
        if (info != null) {
            title = info?.name
        }
        return title
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_cardinfo_wiki

    override fun getFragmentState(): Bundle? = null

    override fun getMainActivityName(): String? = ""

    override fun initComponents() {
        loader = WikiLoader(activity)
    }

    override fun initEvents() {
        innerView.btnGotoWeb.setOnClickListener(this)
        loader?.registerListener(0, this)
    }

    override fun initLogic() {
        info = activity.intent.getSerializableExtra("cardinfo") as CardInfo
        loader?.cardId = info!!.id
        loader?.startLoading()
    }

    override fun initMenu(menu: Menu) { }

    override fun onGetNewArguments(bn: Bundle?) { }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.btnGotoWeb -> {
                val inWeb = Intent(Intent.ACTION_VIEW)
                inWeb.data = Uri.parse(String.format(NetworkDefine.URL_WIKI_FMT, info!!.id))
                startActivity(inWeb)
            }
        }
    }

    override fun onLoadComplete(loader: Loader<String>?, data: String?) {
        try {
            innerView.wvWiki.loadData(data, "text/html; charset=UTF-8", null)
        } catch (e: Exception) {

        }
    }

}