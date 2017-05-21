package com.yugioh.android

import android.Manifest
import android.app.Fragment
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Bundle
import android.view.KeyEvent
import android.widget.Toast
import com.yugioh.android.base.BaseSlidingActivity
import com.yugioh.android.base.InnerFragment
import com.yugioh.android.base.SlidingMenu
import com.yugioh.android.common.Actions
import com.yugioh.android.database.FavDatabase
import com.yugioh.android.database.FavUtils
import com.yugioh.android.database.YugiohDatabase
import com.yugioh.android.database.YugiohUtils
import com.yugioh.android.define.PathDefine
import com.yugioh.android.fragments.*
import com.yugioh.android.intf.IMainIntf
import com.yugioh.android.utils.UIUtils
import com.yugioh.android.utils.UpdateUtils

class MainActivity : BaseSlidingActivity(), IMainIntf {

    internal var currentPage = 0
    private val filterClose = IntentFilter(Actions.ACTION_CLOSE_MAIN)
    private val receiverClose = CloseReceiver()
    private val receiverDatabase = DatabaseMessageReceiver()
    private val filterDatabase = IntentFilter()

    override fun getActionBarCanBack(): Boolean = true

    public override fun onCreate(savedInstanceState: Bundle?) {
        filterDatabase.addAction(Actions.ACTION_EXTRACT_DATABASE)
        filterDatabase.addAction(Actions.ACTION_EXTRACT_DATABASE_COMPLETE)
        registerReceiver(receiverDatabase, filterDatabase)
        super.onCreate(savedInstanceState)
        checkPermission()
        registerReceiver(receiverClose, filterClose)
    }

    fun checkPermission() {
        if (checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
            initDatabase()
        } else {
            requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), 0)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?) {
        if (permissions != null && grantResults != null) {
            (0..permissions.size - 1).forEach {
                if (permissions[it] == Manifest.permission.WRITE_EXTERNAL_STORAGE && grantResults[it] == PackageManager.PERMISSION_GRANTED) {
                    initDatabase()
                }
            }
        }
    }

    private fun initDatabase() {
        PathDefine.init()
        YugiohUtils.newDatabase(this)
        if (!YugiohDatabase.isDatabaseFileExists) {
            Toast.makeText(this, R.string.main_update_database, Toast.LENGTH_LONG).show()
        } else {
            UpdateUtils.updateLocalDatabase(this)
        }
        FavUtils.newFavDatabase(this)
    }

    override fun onDestroy() {
        try {
            unregisterReceiver(receiverClose)
        } catch (e: Exception) {

        }

        try {
            unregisterReceiver(receiverDatabase)
        } catch (e: Exception) {

        }

        super.onDestroy()
    }

    override fun loadFragments() {
    }

    override fun releaseFragments() {
    }

    override fun replaceMenuFragment(): Fragment? = LeftMenuFragment()

    override fun replaceSecondMenuFragment(): Fragment? = RightMenuFragment()

    override fun getBehindOffset(): Int = UIUtils.dip2px(150)

    override fun getAboveTouchMode(): Int = SlidingMenu.TOUCHMODE_MARGIN

    override fun getBehindTouchMode(): Int = SlidingMenu.TOUCHMODE_MARGIN

    override fun getSlideMode(): Int = SlidingMenu.LEFT_RIGHT

    override fun getIcon(): Int = R.drawable.icon

    override fun replaceFragment(): Fragment = SearchFragment()

    override fun customTheme(): Int = 0

    override fun switchPage(page: Int, needToggle: Boolean) {
        if (currentPage != page) {
            currentPage = page
            val f = getCurrentFragment(currentPage)
            if (!f.isAdded) {
                fragmentManager.beginTransaction().replace(R.id.fReplacement, f).commit()
            }
            actionBar.title = getString((f as InnerFragment).getBarTitle())
        }
        if (needToggle) {
            toggle()
        }
    }

    private fun getCurrentFragment(page: Int): Fragment {
        var f: Fragment
        when (page) {
            1 -> f = LimitFragment()  // LIMIT
            2 -> f = NewCardFragment()  // NEW CARD
            3 -> f = PackageListFragment()  // PACKAGE
            4 -> f = FavFragment()  // my fav
            5 -> f = DuelToolFragment()  // DUEL TOOL
            else -> f = SearchFragment()  // MAIN
        }
        return f
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        if (keyCode == KeyEvent.KEYCODE_MENU) {
            toggle()
            return true
        } else if (currentPage != 0 && keyCode == KeyEvent.KEYCODE_BACK) {
            switchPage(0, false)
            return true
        }
        return super.onKeyDown(keyCode, event)
    }

    private fun terminateSelf() {
        finish()
        android.os.Process.killProcess(android.os.Process.myPid())
        System.exit(0)
    }

    inner class CloseReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            terminateSelf()
        }
    }

    inner class DatabaseMessageReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val action = intent.action
            if (action == Actions.ACTION_EXTRACT_DATABASE_COMPLETE) {
                Toast.makeText(this@MainActivity, R.string.main_updated_database, Toast.LENGTH_SHORT).show()
            }
        }
    }
}
