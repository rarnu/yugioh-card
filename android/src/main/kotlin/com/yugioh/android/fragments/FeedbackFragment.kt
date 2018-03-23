package com.yugioh.android.fragments

import android.content.Loader
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.Toast
import com.rarnu.base.app.BaseFragment
import com.yugioh.android.R
import com.yugioh.android.common.MenuIds
import com.yugioh.android.loader.FeedbackSender
import kotlinx.android.synthetic.main.fragment_feedback.view.*

class FeedbackFragment : BaseFragment(), Loader.OnLoadCompleteListener<Boolean> {

    private var itemSend: MenuItem? = null
    private var sender: FeedbackSender? = null

    override fun getBarTitle(): Int = 0

    override fun getBarTitleWithPath(): Int = 0

    override fun getCustomTitle(): String? = null

    override fun initComponents() {
        sender = FeedbackSender(activity)
    }

    override fun initEvents() {
        sender?.registerListener(0, this)
    }

    override fun initLogic() {}

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_feedback

    override fun getMainActivityName(): String? = ""

    override fun initMenu(menu: Menu) {
        itemSend = menu.add(0, MenuIds.MENUID_SEND, 99, R.string.send)
        itemSend?.setIcon(android.R.drawable.ic_menu_send)
        itemSend?.setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            MenuIds.MENUID_SEND -> {
                val text = innerView.etFeedback.text.toString()
                if (text == "") {
                    Toast.makeText(activity, R.string.empty_feedback, Toast.LENGTH_LONG).show()
                    return true
                }
                itemSend?.isEnabled = false
                innerView.etFeedback.isEnabled = false
                innerView.tvSending.visibility = View.VISIBLE
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
            innerView.tvSending.visibility = View.GONE
            itemSend?.isEnabled = true
            innerView.etFeedback.isEnabled = true
            Toast.makeText(activity, if (succ) R.string.feedback_send_ok else R.string.feedback_send_fail, Toast.LENGTH_LONG).show()
            if (succ) {
                activity.finish()
            }
        }
    }
}
