package com.yugioh.android.fragments

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.View
import android.widget.*
import com.yugioh.android.R
import com.yugioh.android.adapter.LinkArrowAdapter
import com.yugioh.android.base.BaseDialogFragment
import com.yugioh.android.classes.LinkArrowItem

class LinkOptionFragment : BaseDialogFragment(), AdapterView.OnItemClickListener, View.OnClickListener {


    internal var list = arrayListOf("不限", "1", "2", "3", "4", "5", "6", "7", "8")
    internal var adapter: ArrayAdapter<String>? = null
    internal var spLinkCount: Spinner? = null
    internal var listArrow = arrayListOf(
            LinkArrowItem(7, "↖", false),
            LinkArrowItem(8, "↑", false),
            LinkArrowItem(9, "↗", false),
            LinkArrowItem(4, "←", false),
            LinkArrowItem(5, "", false),
            LinkArrowItem(6, "→", false),
            LinkArrowItem(1, "↙", false),
            LinkArrowItem(2, "↓", false),
            LinkArrowItem(3, "↘", false)
    )
    internal var adapterArrow: LinkArrowAdapter? = null
    internal var gvLinkArrow: GridView? = null
    internal var btnOK: Button? = null
    internal var btnCancel: Button? = null

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_link_option

    override fun initComponents() {
        spLinkCount = innerView?.findViewById(R.id.spLinkCount) as Spinner?
        adapter = ArrayAdapter(activity, R.layout.item_spin_link, list)
        spLinkCount?.adapter = adapter

        gvLinkArrow = innerView?.findViewById(R.id.gvLinkArrow) as GridView?
        adapterArrow = LinkArrowAdapter(activity, listArrow)
        gvLinkArrow?.adapter = adapterArrow

        btnOK = innerView?.findViewById(R.id.btnOk) as Button?
        btnCancel = innerView?.findViewById(R.id.btnCancel) as Button?
    }

    override fun initEvents() {
        gvLinkArrow?.onItemClickListener = this
        btnOK?.setOnClickListener(this)
        btnCancel?.setOnClickListener(this)
    }

    override fun initLogic() {
        val count = activity.intent.extras.getInt("count", 0)
        spLinkCount?.setSelection(count)
        val arrow = activity.intent.extras.getString("arrow", "")
        val arrowArr = arrow.split(",")
        (0..listArrow.size - 1).forEach {
            if (arrowArr.indexOf(listArrow[it].pos.toString()) != -1) {
                listArrow[it].selected = true
            }
        }
        adapterArrow?.notifyDataSetChanged()
    }

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun getCustomTitle(): String? = null

    override fun getMainActivityName(): String? = null

    override fun initMenu(menu: Menu?) {
    }

    override fun onGetNewArguments(bn: Bundle?) {
    }

    override fun getFragmentState(): Bundle? = null

    override fun onItemClick(adapterView: AdapterView<*>?, view: View?, position: Int, id: Long) {
        if (position == 5) {
            listArrow[position].selected = false
        } else {
            listArrow[position].selected = !listArrow[position].selected
        }
        adapterArrow?.notifyDataSetChanged()
    }

    override fun onClick(v: View) {
        when(v.id) {
            R.id.btnOk -> {
                val inRet = Intent()
                inRet.putExtra("count", spLinkCount!!.selectedItemPosition)
                var arr = ""
                listArrow.filter { it.selected }.forEach { arr += "${it.pos}," }
                arr = arr.trim { it == ',' }
                inRet.putExtra("arrow", arr)
                activity.setResult(Activity.RESULT_OK, inRet)
                activity.finish()
            }
            R.id.btnCancel -> activity.finish()
        }
    }

}
