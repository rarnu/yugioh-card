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
import com.yugioh.android.base.BaseFragment
import com.yugioh.android.common.MenuIds
import com.yugioh.android.utils.ConfigUtils
import com.yugioh.android.utils.UIUtils

class DuelToolFragment : BaseFragment(), OnClickListener {

    internal var tvPlayer1Life: TextView? = null
    internal var tvPlayer2Life: TextView? = null
    internal var etP1Life: EditText? = null
    internal var etP2Life: EditText? = null
    internal var btnP1Add: Button? = null
    internal var btnP2Add: Button? = null
    internal var btnP1Minus: Button? = null
    internal var btnP2Minus: Button? = null
    internal var btnP1Set: Button? = null
    internal var btnP2Set: Button? = null
    internal var btnP1Half: Button? = null
    internal var btnP2Half: Button? = null
    internal var btnP1Double: Button? = null
    internal var btnP2Double: Button? = null
    internal var btnP1Divide: Button? = null
    internal var btnP2Divide: Button? = null
    internal var btnP1Opt: Button? = null
    internal var btnP2Opt: Button? = null
    internal var btnCoin: Button? = null
    internal var btnDice: Button? = null
    internal var itemResetDuel: MenuItem? = null
    private var Player1Life = 8000
    private var Player2Life = 8000

    override fun getBarTitle(): Int = R.string.lm_tool

    override fun getBarTitleWithPath(): Int = R.string.lm_tool

    override fun getCustomTitle(): String? = null

    override fun getFragmentLayoutResId(): Int = R.layout.fragment_tool

    override fun getMainActivityName(): String? = ""

    override fun initComponents() {
        tvPlayer1Life = innerView?.findViewById(R.id.tvPlayer1Life) as TextView?
        tvPlayer2Life = innerView?.findViewById(R.id.tvPlayer2Life) as TextView?
        etP1Life = innerView?.findViewById(R.id.etP1Life) as EditText?
        etP2Life = innerView?.findViewById(R.id.etP2Life) as EditText?
        btnP1Add = innerView?.findViewById(R.id.btnP1Add) as Button?
        btnP2Add = innerView?.findViewById(R.id.btnP2Add) as Button?
        btnP1Minus = innerView?.findViewById(R.id.btnP1Minus) as Button?
        btnP2Minus = innerView?.findViewById(R.id.btnP2Minus) as Button?
        btnP1Set = innerView?.findViewById(R.id.btnP1Set) as Button?
        btnP2Set = innerView?.findViewById(R.id.btnP2Set) as Button?

        btnP1Half = innerView?.findViewById(R.id.btnP1Half) as Button?
        btnP2Half = innerView?.findViewById(R.id.btnP2Half) as Button?
        btnP1Double = innerView?.findViewById(R.id.btnP1Double) as Button?
        btnP2Double = innerView?.findViewById(R.id.btnP2Double) as Button?
        btnP1Divide = innerView?.findViewById(R.id.btnP1Divide) as Button?
        btnP2Divide = innerView?.findViewById(R.id.btnP2Divide) as Button?
        btnP1Opt = innerView?.findViewById(R.id.btnP1Opt) as Button?
        btnP2Opt = innerView?.findViewById(R.id.btnP2Opt) as Button?

        btnCoin = innerView?.findViewById(R.id.btnCoin) as Button?
        btnDice = innerView?.findViewById(R.id.btnDice) as Button?

        setToolButtonLayout()

    }

    override fun initEvents() {
        btnP1Add?.setOnClickListener(this)
        btnP2Add?.setOnClickListener(this)
        btnP1Minus?.setOnClickListener(this)
        btnP2Minus?.setOnClickListener(this)
        btnP1Set?.setOnClickListener(this)
        btnP2Set?.setOnClickListener(this)

        btnP1Half?.setOnClickListener(this)
        btnP2Half?.setOnClickListener(this)
        btnP1Double?.setOnClickListener(this)
        btnP2Double?.setOnClickListener(this)
        btnP1Divide?.setOnClickListener(this)
        btnP2Divide?.setOnClickListener(this)
        btnP1Opt?.setOnClickListener(this)
        btnP2Opt?.setOnClickListener(this)

        btnCoin?.setOnClickListener(this)
        btnDice?.setOnClickListener(this)
    }

    private fun setToolButtonLayout() {
        var width = (UIUtils.width!! - UIUtils.dip2px(16)) / 4
        UIUtils.setViewWidth(btnP1Half, width)
        UIUtils.setViewWidth(btnP2Half, width)
        UIUtils.setViewWidth(btnP1Double, width)
        UIUtils.setViewWidth(btnP2Double, width)
        UIUtils.setViewWidth(btnP1Divide, width)
        UIUtils.setViewWidth(btnP2Divide, width)
        UIUtils.setViewWidth(btnP1Opt, width)
        UIUtils.setViewWidth(btnP2Opt, width)

        width = (UIUtils.width!! - UIUtils.dip2px(16)) / 2
        UIUtils.setViewWidth(btnCoin, width)
        UIUtils.setViewWidth(btnDice, width)
    }

    override fun initLogic() {
        restoreLifePoints()
    }

    override fun initMenu(menu: Menu?) {
        itemResetDuel = menu?.add(0, MenuIds.MENUID_RESET_DUEL, 99, R.string.tool_reset)
        itemResetDuel?.setIcon(android.R.drawable.ic_menu_revert)
        itemResetDuel?.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            MenuIds.MENUID_RESET_DUEL -> {
                Player1Life = 8000
                Player2Life = 8000
                setLifePoint(tvPlayer1Life, Player1Life)
                setLifePoint(tvPlayer2Life, Player2Life)
            }
        }
        return true
    }

    override fun onGetNewArguments(bn: Bundle?) {
    }

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
        setLifePoint(tvPlayer1Life, Player1Life)
        setLifePoint(tvPlayer2Life, Player2Life)
    }

    override fun onClick(v: View) {
        var point: Int
        var life: Int

        when (v.id) {
            R.id.btnP1Add -> {
                if (etP1Life?.text.toString() == "") {
                    Toast.makeText(activity, R.string.tool_number_reqired, Toast.LENGTH_LONG).show()
                    return
                }
                point = Integer.parseInt(etP1Life?.text.toString())
                Player1Life += point
                setLifePoint(tvPlayer1Life, Player1Life)
                etP1Life?.setText("")
            }
            R.id.btnP2Add -> {
                if (etP2Life?.text.toString() == "") {
                    Toast.makeText(activity, R.string.tool_number_reqired, Toast.LENGTH_LONG).show()
                    return
                }
                point = Integer.parseInt(etP2Life?.text.toString())
                Player2Life += point
                setLifePoint(tvPlayer2Life, Player2Life)
                etP2Life?.setText("")
            }
            R.id.btnP1Minus -> {
                if (etP1Life?.text.toString() == "") {
                    Toast.makeText(activity, R.string.tool_number_reqired, Toast.LENGTH_LONG).show()
                    return
                }
                point = Integer.parseInt(etP1Life?.text.toString())
                Player1Life -= point
                if (Player1Life < 0) {
                    Player1Life = 0
                }
                setLifePoint(tvPlayer1Life, Player1Life)
                etP1Life?.setText("")
            }
            R.id.btnP2Minus -> {
                if (etP2Life?.text.toString() == "") {
                    Toast.makeText(activity, R.string.tool_number_reqired, Toast.LENGTH_LONG).show()
                    return
                }
                point = Integer.parseInt(etP2Life?.text.toString())
                Player2Life -= point
                if (Player2Life < 0) {
                    Player2Life = 0
                }
                setLifePoint(tvPlayer2Life, Player2Life)
                etP2Life?.setText("")
            }
            R.id.btnP1Set -> {
                if (etP1Life?.text.toString() == "") {
                    Toast.makeText(activity, R.string.tool_number_reqired, Toast.LENGTH_LONG).show()
                    return
                }
                point = Integer.parseInt(etP1Life?.text.toString())
                Player1Life = point
                setLifePoint(tvPlayer1Life, Player1Life)
                etP1Life?.setText("")
            }
            R.id.btnP2Set -> {
                if (etP2Life?.text.toString() == "") {
                    Toast.makeText(activity, R.string.tool_number_reqired, Toast.LENGTH_LONG).show()
                    return
                }
                point = Integer.parseInt(etP2Life?.text.toString())
                Player2Life = point
                setLifePoint(tvPlayer2Life, Player2Life)
                etP2Life?.setText("")
            }

            R.id.btnP1Half -> {
                if (Player1Life % 2 != 0) {
                    Player1Life += 1
                }
                Player1Life /= 2
                setLifePoint(tvPlayer1Life, Player1Life)
            }

            R.id.btnP2Half -> {
                if (Player2Life % 2 != 0) {
                    Player2Life += 1
                }
                Player2Life /= 2
                setLifePoint(tvPlayer2Life, Player2Life)
            }

            R.id.btnP1Double -> {
                Player1Life *= 2
                setLifePoint(tvPlayer1Life, Player1Life)
            }

            R.id.btnP2Double -> {
                Player2Life *= 2
                setLifePoint(tvPlayer2Life, Player2Life)
            }
            R.id.btnP1Divide -> {
                life = Player1Life + Player2Life
                if (life % 2 != 0) {
                    life += 1
                }
                life /= 2
                Player1Life = life
                Player2Life = life
                setLifePoint(tvPlayer1Life, Player1Life)
                setLifePoint(tvPlayer2Life, Player2Life)
            }

            R.id.btnP2Divide -> {
                life = Player1Life + Player2Life
                if (life % 2 != 0) {
                    life += 1
                }
                life /= 2
                Player1Life = life
                Player2Life = life
                setLifePoint(tvPlayer1Life, Player1Life)
                setLifePoint(tvPlayer2Life, Player2Life)
            }

            R.id.btnP1Opt -> {
                Player1Life = Player2Life
                setLifePoint(tvPlayer1Life, Player1Life)
            }

            R.id.btnP2Opt -> {
                Player2Life = Player1Life
                setLifePoint(tvPlayer2Life, Player2Life)
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
