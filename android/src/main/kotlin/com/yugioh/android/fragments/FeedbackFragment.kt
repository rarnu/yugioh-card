package com.yugioh.android.fragments

import android.content.Loader
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import com.yugioh.android.R
import com.yugioh.android.base.BaseFragment
import com.yugioh.android.common.MenuIds
import com.yugioh.android.loader.FeedbackSender

class FeedbackFragment : BaseFragment(), Loader.OnLoadCompleteListener<Boolean> {

    internal var itemSend: MenuItem? = null
    internal var etFeedback: EditText? = null
    internal var sender: FeedbackSender? = null
    internal var tvSending: TextView? = null

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun getCustomTitle(): String? = null

    override fun initComponents() {
        etFeedback = innerView?.findViewById(R.id.etFeedback) as EditText?
        sender = FeedbackSender(activity)
        tvSending = innerView?.findViewById(R.id.tvSending) as TextView?
    }

    override fun initEvents() {
        sender?.registerListener(0, this)
    }

    override fun initLogic() {}

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_feedback


    override fun getMainActivityName(): String? = ""


    override fun initMenu(menu: Menu?) {
        itemSend = menu?.add(0, MenuIds.MENUID_SEND, 99, R.string.send)
        itemSend?.setIcon(android.R.drawable.ic_menu_send)
        itemSend?.setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            MenuIds.MENUID_SEND -> {
                val text = etFeedback?.text.toString()
                if (text == "") {
                    Toast.makeText(activity, R.string.empty_feedback, Toast.LENGTH_LONG).show()
                    return true
                }
                itemSend?.isEnabled = false
                etFeedback?.isEnabled = false
                tvSending?.visibility = View.VISIBLE
                sender?.text = text
                sender?.startLoading()
            }
        }
        return true
    }

    override fun onGetNewArguments(bn: Bundle?) {}

    override fun getFragmentState(): Bundle? = null


    override fun onLoadComplete(loader: Loader<Boolean>, data: Boolean?) {
        var succ = false
        if (data != null) {
            succ = data
        }
        if (activity != null) {
            tvSending?.visibility = View.GONE
            itemSend?.isEnabled = true
            etFeedback?.isEnabled = true
            Toast.makeText(activity, if (succ) R.string.feedback_send_ok else R.string.feedback_send_fail, Toast.LENGTH_LONG).show()
            if (succ) {
                activity.finish()
            }
        }
    }
}
