package com.yugioh.android.utils

import android.content.Context
import android.os.Build
import com.rarnu.base.utils.AccountUtils
import com.rarnu.base.utils.DeviceUtils
import com.rarnu.base.utils.HttpUtils
import com.yugioh.android.classes.*
import com.yugioh.android.define.NetworkDefine
import org.json.JSONArray
import org.json.JSONObject

import java.net.URLEncoder
import java.util.ArrayList

object YGOAPI {

    fun findUpdate(context: Context, dbVer: Int, lastCardId: Int): UpdateInfo? {
        val param = String.format(NetworkDefine.UPDATE_PARAM_FMT, DeviceUtils.getAppVersionCode(context), lastCardId, dbVer)
        var ui: UpdateInfo? = null
        try {
            val jsonstr = HttpUtils.get(NetworkDefine.UPDATE_URL, param)
            val json = JSONObject(jsonstr)
            ui = UpdateInfo()
            ui.updateApk = json.getInt("apk")
            ui.updateData = json.getInt("data")
            ui.newCard = json.getInt("newcard")
            ui.apkVersion = json.getString("apkversion")
        } catch (e: Exception) {

        }
        return ui
    }

    val recommands: MutableList<RecommandInfo>?
        get() {
            var list: MutableList<RecommandInfo>? = null
            try {
                val ret = HttpUtils.get(NetworkDefine.RECOMMAND_URL, "")
                val json = JSONObject(ret)
                val jarr = json.getJSONArray("data")
                list = ArrayList<RecommandInfo>()
                for (i in 0..jarr.length() - 1) {
                    val item = RecommandInfo()
                    item.id = jarr.getJSONObject(i).getInt("id")
                    item.name = jarr.getJSONObject(i).getString("name")
                    item.jumpMode = jarr.getJSONObject(i).getInt("jump_mode")
                    item.jumpUrl = jarr.getJSONObject(i).getString("jump_url")
                    item.jumpText = jarr.getJSONObject(i).getString("jump_text")
                    item.imagePath = jarr.getJSONObject(i).getString("image_name")
                    item.bigQR = jarr.getJSONObject(i).getString("big_qr")
                    list.add(item)
                }
            } catch (e: Exception) {

            }
            return list
        }

    val packageList: MutableList<PackageItem>?
        get() {
            var list: MutableList<PackageItem>? = null
            try {
                val ret = HttpUtils.get(NetworkDefine.URL_OCGSOFT_GET_PACKAGE, "")
                val jarr = JSONArray(ret)

                list = ArrayList<PackageItem>()
                var jobj: JSONObject?
                var jarrPkg: JSONArray?
                for (i in 0..jarr.length() - 1) {
                    jobj = jarr.getJSONObject(i)
                    list.add(PackageItem(true, "", jobj!!.getString("serial")))
                    jarrPkg = jobj.getJSONArray("packages")
                    for (j in 0..jarrPkg!!.length() - 1) {
                        list.add(PackageItem(false, jarrPkg.getJSONObject(j).getString("id"), jarrPkg.getJSONObject(j).getString("packname")))
                    }
                }
            } catch (e: Exception) {

            }

            return list
        }

    fun getPackageCards(id: String): CardItems? {
        var item: CardItems? = null
        try {
            val ret = HttpUtils.get(String.format(NetworkDefine.URL_OCGSOFT_GET_PACKAGE_CARD, id), "")
            val json = JSONObject(ret)
            item = CardItems()
            item.packageName = json.getString("name")
            val jarr = json.getJSONArray("cards")
            item.cardIds = IntArray(jarr.length())
            for (i in 0..jarr.length() - 1) {
                item.cardIds!![i] = jarr.getInt(i)
            }
        } catch (e: Exception) {

        }

        return item
    }

    // TODO: fake method
    val deckList: MutableList<DeckItem>?
        get() {
            val list = ArrayList<DeckItem>()
            list.add(DeckItem("1", "DEMO1", "DEMO"))
            list.add(DeckItem("2", "DEMO2", "DEMO"))
            list.add(DeckItem("3", "DEMO3", "DEMO"))
            return list
        }

    fun getDeckCards(id: String): CardItems? {
        // TODO: fake method
        val items = CardItems()
        items.packageName = id
        items.cardIds = IntArray(40)
        for (i in 0..39) {
            items.cardIds!![i] = i + 50
        }
        return items
    }

    fun sendFeedback(context: Context, text: String?): Boolean {
        var text = text
        var ret = false
        try {
            val deviceId = DeviceUtils.getDeviceUniqueId(context)
            val email = URLEncoder.encode(AccountUtils.getBindedEmailAddress(context), "UTF-8")
            text = URLEncoder.encode(text, "UTF-8")
            val appver = DeviceUtils.getAppVersionCode(context)
            val osver = Build.VERSION.SDK_INT
            val str = HttpUtils.get(NetworkDefine.FEEDBACK_URL, String.format(NetworkDefine.FEEDBACK_PARAM_FMT, deviceId, email, text, appver, osver))
            ret = str != "0"
        } catch (e: Exception) {

        }

        return ret
    }

    val updateLog: String?
        get() {
            var ret: String? = ""
            try {
                ret = HttpUtils.get(NetworkDefine.URL_UPDATE_LOG, "")
            } catch (e: Exception) {

            }
            return ret
        }
}
