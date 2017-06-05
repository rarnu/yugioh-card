package com.yugioh.android.fragments

import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.view.View.OnClickListener
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import com.yugioh.android.CoinDiceActivity
import com.yugioh.android.R
import com.rarnu.base.app.BaseFragment
import com.rarnu.base.utils.ConfigUtils
import com.rarnu.base.utils.UIUtils
import com.yugioh.android.common.MenuIds
import kotlinx.android.synthetic.main.fragment_tool.view.*

class DuelToolFragment : BaseFragment(), OnClickListener {

    internal var itemResetDuel: MenuItem? = null
    private var Player1Life = 8000
    private var Player2Life = 8000

    override fun getBarTitle(): Int = R.string.lm_tool

    override fun getBarTitleWithPath(): Int = R.string.lm_tool

    override fun getCustomTitle(): String? = null

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_tool

    override fun getMainActivityName(): String? = ""

    override fun initComponents() {
        setToolButtonLayout()

    }

    override fun initEvents() {
        innerView.btnP1Add.setOnClickListener(this)
        innerView.btnP2Add.setOnClickListener(this)
        innerView.btnP1Minus.setOnClickListener(this)
        innerView.btnP2Minus.setOnClickListener(this)
        innerView.btnP1Set.setOnClickListener(this)
        innerView.btnP2Set.setOnClickListener(this)

        innerView.btnP1Half.setOnClickListener(this)
        innerView.btnP2Half.setOnClickListener(this)
        innerView.btnP1Double.setOnClickListener(this)
        innerView.btnP2Double.setOnClickListener(this)
        innerView.btnP1Divide.setOnClickListener(this)
        innerView.btnP2Divide.setOnClickListener(this)
        innerView.btnP1Opt.setOnClickListener(this)
        innerView.btnP2Opt.setOnClickListener(this)

        innerView.btnCoin.setOnClickListener(this)
        innerView.btnDice.setOnClickListener(this)
    }

    private fun setToolButtonLayout() {
        var width = (UIUtils.width!! - UIUtils.dip2px(16)) / 4
        UIUtils.setViewWidth(innerView.btnP1Half, width)
        UIUtils.setViewWidth(innerView.btnP2Half, width)
        UIUtils.setViewWidth(innerView.btnP1Double, width)
        UIUtils.setViewWidth(innerView.btnP2Double, width)
        UIUtils.setViewWidth(innerView.btnP1Divide, width)
        UIUtils.setViewWidth(innerView.btnP2Divide, width)
        UIUtils.setViewWidth(innerView.btnP1Opt, width)
        UIUtils.setViewWidth(innerView.btnP2Opt, width)

        width = (UIUtils.width!! - UIUtils.dip2px(16)) / 2
        UIUtils.setViewWidth(innerView.btnCoin, width)
        UIUtils.setViewWidth(innerView.btnDice, width)
    }

    override fun initLogic() {
        restoreLifePoints()
    }

    override fun initMenu(menu: Menu) {
        itemResetDuel = menu.add(0, MenuIds.MENUID_RESET_DUEL, 99, R.string.tool_reset)
        itemResetDuel?.setIcon(android.R.drawable.ic_menu_revert)
        itemResetDuel?.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            MenuIds.MENUID_RESET_DUEL -> {
                Player1Life = 8000
                Player2Life = 8000
                setLifePoint(innerView.tvPlayer1Life, Player1Life)
                setLifePoint(innerView.tvPlayer2Life, Player2Life)
            }
        }
        return true
    }

    override fun onGetNewArguments(bn: Bundle?) { }

    override fun onPause() {
        backupLifePoints()
        super.onPause()
    }

    override fun onResume() {
        super.onResume()
        restoreLifePoints()
    }

    private fun backupLifePoints() {
        ConfigUtils.setIntConfig(activity, KEY_P1LIFE, Player1Life)
        ConfigUtils.setIntConfig(activity, KEY_P2LIFE, Player2Life)
    }

    private fun restoreLifePoints() {
        Player1Life = ConfigUtils.getIntConfig(activity, KEY_P1LIFE, 8000)!!
        Player2Life = ConfigUtils.getIntConfig(activity, KEY_P2LIFE, 8000)!!
        setLifePoint(innerView.tvPlayer1Life, Player1Life)
        setLifePoint(innerView.tvPlayer2Life, Player2Life)
    }

    override fun onClick(v: View) {
        var point: Int
        var life: Int

        when (v.id) {
            R.id.btnP1Add -> {
                if (innerView.etP1Life.text.toString() == "") {
                    Toast.makeText(activity, R.string.tool_number_reqired, Toast.LENGTH_LONG).show()
                    return
                }
                point = Integer.parseInt(innerView.etP1Life.text.toString())
                Player1Life += point
                setLifePoint(innerView.tvPlayer1Life, Player1Life)
                innerView.etP1Life.setText("")
            }
            R.id.btnP2Add -> {
                if (innerView.etP2Life.text.toString() == "") {
                    Toast.makeText(activity, R.string.tool_number_reqired, Toast.LENGTH_LONG).show()
                    return
                }
                point = Integer.parseInt(innerView.etP2Life.text.toString())
                Player2Life += point
                setLifePoint(innerView.tvPlayer2Life, Player2Life)
                innerView.etP2Life.setText("")
            }
            R.id.btnP1Minus -> {
                if (innerView.etP1Life.text.toString() == "") {
                    Toast.makeText(activity, R.string.tool_number_reqired, Toast.LENGTH_LONG).show()
                    return
                }
                point = Integer.parseInt(innerView.etP1Life.text.toString())
                Player1Life -= point
                if (Player1Life < 0) {
                    Player1Life = 0
                }
                setLifePoint(innerView.tvPlayer1Life, Player1Life)
                innerView.etP1Life.setText("")
            }
            R.id.btnP2Minus -> {
                if (innerView.etP2Life.text.toString() == "") {
                    Toast.makeText(activity, R.string.tool_number_reqired, Toast.LENGTH_LONG).show()
                    return
                }
                point = Integer.parseInt(innerView.etP2Life.text.toString())
                Player2Life -= point
                if (Player2Life < 0) {
                    Player2Life = 0
                }
                setLifePoint(innerView.tvPlayer2Life, Player2Life)
                innerView.etP2Life.setText("")
            }
            R.id.btnP1Set -> {
                if (innerView.etP1Life.text.toString() == "") {
                    Toast.makeText(activity, R.string.tool_number_reqired, Toast.LENGTH_LONG).show()
                    return
                }
                point = Integer.parseInt(innerView.etP1Life.text.toString())
                Player1Life = point
                setLifePoint(innerView.tvPlayer1Life, Player1Life)
                innerView.etP1Life.setText("")
            }
            R.id.btnP2Set -> {
                if (innerView.etP2Life.text.toString() == "") {
                    Toast.makeText(activity, R.string.tool_number_reqired, Toast.LENGTH_LONG).show()
                    return
                }
                point = Integer.parseInt(innerView.etP2Life.text.toString())
                Player2Life = point
                setLifePoint(innerView.tvPlayer2Life, Player2Life)
                innerView.etP2Life.setText("")
            }

            R.id.btnP1Half -> {
                if (Player1Life % 2 != 0) {
                    Player1Life += 1
                }
                Player1Life /= 2
                setLifePoint(innerView.tvPlayer1Life, Player1Life)
            }

            R.id.btnP2Half -> {
                if (Player2Life % 2 != 0) {
                    Player2Life += 1
                }
                Player2Life /= 2
                setLifePoint(innerView.tvPlayer2Life, Player2Life)
            }

            R.id.btnP1Double -> {
                Player1Life *= 2
                setLifePoint(innerView.tvPlayer1Life, Player1Life)
            }

            R.id.btnP2Double -> {
                Player2Life *= 2
                setLifePoint(innerView.tvPlayer2Life, Player2Life)
            }
            R.id.btnP1Divide -> {
                life = Player1Life + Player2Life
                if (life % 2 != 0) {
                    life += 1
                }
                life /= 2
                Player1Life = life
                Player2Life = life
                setLifePoint(innerView.tvPlayer1Life, Player1Life)
                setLifePoint(innerView.tvPlayer2Life, Player2Life)
            }

            R.id.btnP2Divide -> {
                life = Player1Life + Player2Life
                if (life % 2 != 0) {
                    life += 1
                }
                life /= 2
                Player1Life = life
                Player2Life = life
                setLifePoint(innerView.tvPlayer1Life, Player1Life)
                setLifePoint(innerView.tvPlayer2Life, Player2Life)
            }

            R.id.btnP1Opt -> {
                Player1Life = Player2Life
                setLifePoint(innerView.tvPlayer1Life, Player1Life)
            }

            R.id.btnP2Opt -> {
                Player2Life = Player1Life
                setLifePoint(innerView.tvPlayer2Life, Player2Life)
            }

            R.id.btnDice -> {
                val inDice = Intent(activity, CoinDiceActivity::class.java)
                inDice.putExtra("type", 1)
                startActivity(inDice)
            }
            R.id.btnCoin -> {
                val inCoin = Intent(activity, CoinDiceActivity::class.java)
                inCoin.putExtra("type", 2)
                startActivity(inCoin)
            }
        }

    }

    private fun setLifePoint(tv: TextView?, life: Int) {
        tv?.text = life.toString()
    }

    override fun getFragmentState(): Bundle? = null

    companion object {
        private val KEY_P1LIFE = "key_p1_life"
        private val KEY_P2LIFE = "key_p2_life"
    }

}
