package com.yugioh.android.fragments

import android.app.Activity
import android.app.Fragment
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import com.yugioh.android.R
import com.rarnu.base.app.BaseTabFragment
import com.yugioh.android.classes.CardInfo
import com.yugioh.android.common.MenuIds
import com.yugioh.android.database.FavUtils
import com.yugioh.android.define.PathDefine

import java.io.File

class CardInfoFragment : BaseTabFragment() {

    internal var itemFav: MenuItem? = null
    internal var info: CardInfo? = null

    init {
        tabTitle = ""
    }

    @Suppress("DEPRECATION")
    override fun onAttach(activity: Activity) {
        super.onAttach(activity)
        info = getActivity().intent.getSerializableExtra("cardinfo") as CardInfo
    }

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun getMainActivityName(): String? = ""

    override fun initMenu(menu: Menu?) {
        itemFav = menu?.add(0, MenuIds.MENUID_FAV, 98, R.string.fav)
        itemFav?.setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM)
        itemFav?.setIcon(if (FavUtils.queryFav(activity, info!!.id)) android.R.drawable.ic_menu_close_clear_cancel else android.R.drawable.ic_menu_add)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            MenuIds.MENUID_FAV -> {
                val isFav = FavUtils.queryFav(activity, info!!.id)
                if (isFav) {
                    FavUtils.removeFav(activity, info!!.id)
                    itemFav?.setIcon(android.R.drawable.ic_menu_add)
                } else {
                    FavUtils.addFav(activity, info!!.id)
                    itemFav?.setIcon(android.R.drawable.ic_menu_close_clear_cancel)
                }
            }
        }
        return true
    }

    private val shareIntent: Intent
        get() {
            val shareIntent = Intent(Intent.ACTION_SEND)
            shareIntent.type = "image/*"
            val uri = Uri.fromFile(File(PathDefine.PICTURE_PATH+ "${info?.id}.jpg"))
            shareIntent.putExtra(Intent.EXTRA_STREAM, uri)
            shareIntent.putExtra(Intent.EXTRA_TEXT, "Share one cadrd")
            return shareIntent
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

    override fun initFragmentList(listFragment: MutableList<Fragment?>?) {
        listFragment?.add(CardInfoCardFragment())
        listFragment?.add(CardInfoAdjustFragment())
        listFragment?.add(CardInfoPictureFragment())
    }

    override fun getFragmentState(): Bundle? = null

}
