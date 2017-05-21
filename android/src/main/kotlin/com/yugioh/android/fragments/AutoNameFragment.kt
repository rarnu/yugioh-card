package com.yugioh.android.fragments

import android.app.Activity
import android.content.Intent
import android.content.Loader
import android.database.Cursor
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.Menu
import android.view.View
import android.widget.*
import com.yugioh.android.R
import com.yugioh.android.base.BaseFragment
import com.yugioh.android.loader.AutoNameLoader

class AutoNameFragment : BaseFragment(), AdapterView.OnItemClickListener, View.OnClickListener, Loader.OnLoadCompleteListener<Cursor> {

    internal var etCardName: EditText? = null
    internal var btnSearch: ImageView? = null
    internal var lvHint: ListView? = null
    internal var cSearchResult: Cursor? = null
    internal var adapterSearchResult: SimpleCursorAdapter? = null
    internal var loader: AutoNameLoader? = null

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun getCustomTitle(): String? = null

    override fun initComponents() {
        etCardName = innerView?.findViewById(R.id.etCardName) as EditText?
        btnSearch = innerView?.findViewById(R.id.btnSearch) as ImageView?
        lvHint = innerView?.findViewById(R.id.lvHint) as ListView?
        loader = AutoNameLoader(activity)
    }

    override fun initEvents() {
        etCardName?.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable?) {
                doSearchHint()
            }
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {
            }
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
            }
        })
        lvHint?.onItemClickListener = this
        btnSearch?.setOnClickListener(this)
        loader?.registerListener(0, this)
    }

    override fun initLogic() {
        etCardName?.requestFocus()
        val name = arguments.getString("name")
        etCardName?.setText(name)
        if (name != "") {
            doSearchHint()
            etCardName?.setSelection(etCardName?.text.toString().length)
        }
    }

    private fun doSearchHint() {
        loader?.name = etCardName?.text.toString()
        loader?.startLoading()
    }

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_auto_name

    override fun getMainActivityName(): String? = ""

    override fun initMenu(menu: Menu?) {}

    override fun onGetNewArguments(bn: Bundle?) {}

    override fun getFragmentState(): Bundle? = null

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        if (cSearchResult != null) {
            cSearchResult!!.moveToPosition(position)
            etCardName?.setText(cSearchResult!!.getString(cSearchResult!!.getColumnIndex("name")))
            etCardName?.setSelection(etCardName?.text.toString().length)
        }
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.btnSearch -> {
                val inRet = Intent()
                inRet.putExtra("name", etCardName?.text.toString())
                activity.setResult(Activity.RESULT_OK, inRet)
                activity.finish()
            }
        }

    }

    override fun onLoadComplete(loader: Loader<Cursor>, data: Cursor?) {
        if (data != null) {
            cSearchResult = data
            adapterSearchResult = SimpleCursorAdapter(activity, R.layout.item_card, cSearchResult, arrayOf("name"), intArrayOf(R.id.tvCardName), CursorAdapter.FLAG_REGISTER_CONTENT_OBSERVER)
        } else {
            adapterSearchResult = null
        }
        if (activity != null) {
            lvHint?.adapter = adapterSearchResult
        }
    }
}
