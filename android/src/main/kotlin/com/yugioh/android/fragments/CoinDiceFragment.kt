package com.yugioh.android.fragments

import android.os.Bundle
import android.view.Menu
import android.view.View
import android.view.View.OnClickListener
import com.rarnu.base.app.BaseFragment
import com.yugioh.android.R
import kotlinx.android.synthetic.main.fragment_coindice.view.*
import java.util.*

class CoinDiceFragment : BaseFragment(), OnClickListener {

    internal var tmrCloseWindow: Timer? = null
    internal var type = 0
    internal var count = 0
    private var _dice = intArrayOf(R.drawable.dice1, R.drawable.dice2, R.drawable.dice3, R.drawable.dice4, R.drawable.dice5, R.drawable.dice6)
    private var _coin = intArrayOf(R.drawable.coin1, R.drawable.coin2)

    override fun getBarTitle(): Int = R.string.page_tool

    override fun getBarTitleWithPath(): Int = R.string.page_tool

    override fun getCustomTitle(): String? = null

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_coindice

    override fun getMainActivityName(): String? = ""

    override fun initComponents() { }

    override fun initEvents() {
        innerView.imgCoinDice.setOnClickListener(this)
    }

    override fun initLogic() {
        type = activity.intent.getIntExtra("type", 0)
        if (type == 0) {
            activity.finish()
            return
        }
        count = 0
        if (type == 1) {
            doDice()
        } else if (type == 2) {
            doCoin()
        }

        tmrCloseWindow = Timer()
        tmrCloseWindow!!.schedule(object : TimerTask() {

            override fun run() {
                tmrCloseWindow!!.cancel()
                activity.runOnUiThread {
                    doClose()
                }
            }
        }, 2000)

    }

    override fun onDestroy() {
        stopTimer()
        super.onDestroy()
    }

    override fun initMenu(menu: Menu) { }

    override fun onGetNewArguments(bn: Bundle?) { }

    private fun doDice() {
        // dice
        count++
        val dice = (Math.random() * 6 + 1).toInt()
        innerView.imgCoinDice.setImageResource(_dice[dice - 1])
    }

    private fun doCoin() {
        // coin
        count++
        val coin = (Math.random() * 2 + 1).toInt()
        innerView.imgCoinDice.setImageResource(_coin[coin - 1])
    }

    override fun onClick(v: View) {
        stopTimer()
        doClose()
    }

    private fun stopTimer() {
        try {
            tmrCloseWindow!!.cancel()
        } catch (e: Exception) {

        }
        tmrCloseWindow = null
    }

    private fun doClose() {
        try {
            activity.finish()
        } catch (e: Exception) {

        }
    }

    override fun getFragmentState(): Bundle? = null

}
