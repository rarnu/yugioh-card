package com.yugioh.android.fragments

import android.content.Loader
import android.database.Cursor
import android.os.Bundle
import android.view.Menu
import android.view.View
import android.widget.*
import com.yugioh.android.R
import com.rarnu.base.app.BaseFragment
import com.yugioh.android.loader.FavLoader
import com.yugioh.android.utils.MiscUtils
import kotlinx.android.synthetic.main.fragment_myfav.view.*

class FavFragment : BaseFragment(), Loader.OnLoadCompleteListener<Cursor>, AdapterView.OnItemClickListener {

    internal var loader: FavLoader? = null
    internal var cSearch: Cursor? = null
    internal var adapterSearch: SimpleCursorAdapter? = null

    override fun getBarTitle(): Int = R.string.lm_myfav

    override fun getBarTitleWithPath(): Int = R.string.lm_myfav

    override fun getCustomTitle(): String? = null

    override fun initComponents() {
        loader = FavLoader(activity)
    }

    override fun initEvents() {
        loader?.registerListener(0, this)
        innerView.lvList.onItemClickListener = this
    }

    override fun initLogic() { }

    override fun onResume() {
        super.onResume()
        loader?.startLoading()
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_myfav

    override fun getMainActivityName(): String? = ""

    override fun initMenu(menu: Menu) { }

    override fun onGetNewArguments(bn: Bundle?) {}

    override fun getFragmentState(): Bundle? = null

    override fun onLoadComplete(loader: Loader<Cursor>, data: Cursor?) {
        if (data != null) {
            cSearch = data
            adapterSearch = SimpleCursorAdapter(activity, R.layout.item_card, cSearch, arrayOf("name", "sCardType"), intArrayOf(R.id.tvCardName, R.id.tvCardType), CursorAdapter.FLAG_REGISTER_CONTENT_OBSERVER)
        } else {
            adapterSearch = null
        }
        if (activity != null) {
            innerView.lvList.adapter = adapterSearch
            innerView.tvListNoCard.visibility = if (adapterSearch == null || adapterSearch!!.count == 0) View.VISIBLE else View.GONE
        }
    }

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        MiscUtils.openCardDetail(activity, cSearch, position)
    }
}
