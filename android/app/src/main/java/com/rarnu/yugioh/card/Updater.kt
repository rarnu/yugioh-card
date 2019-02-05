package com.rarnu.yugioh.card

import android.app.Activity
import android.content.Intent
import android.net.Uri
import com.rarnu.kt.android.HttpMethod
import com.rarnu.kt.android.alert
import com.rarnu.kt.android.httpAsync
import com.rarnu.kt.android.resStr
import org.json.JSONObject

object Updater {

    private const val VERSIONCODE = 2
    private const val UPDATE_URL = "https://github.com/rarnu/yugioh-card/raw/master/update/update.json"

    fun checkUpdate(activity: Activity) = with(activity) {
        httpAsync {

            url = UPDATE_URL
            method = HttpMethod.GET
            onSuccess { code, text, _ ->
                if (code == 200) {
                    try {
                        val json = JSONObject(text)
                        val jobj = json.getJSONObject("android")
                        if (jobj.getInt("code") > VERSIONCODE) {
                            runOnUiThread {
                                alert(resStr(R.string.alert_update), resStr(R.string.alert_update_message), resStr(R.string.alert_ok), resStr(R.string.alert_cancel)) { which ->
                                    if (which == 0) {
                                        val inDownload = Intent(Intent.ACTION_VIEW)
                                        inDownload.data = Uri.parse("https://raw.githubusercontent.com/rarnu/yugioh-card/master/update/${jobj.getString("url")}")
                                        startActivity(inDownload)
                                    }
                                }
                            }
                        }
                    } catch (e: Exception) {

                    }
                }
            }
        }
    }

}