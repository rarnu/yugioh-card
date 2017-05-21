package com.yugioh.android.common

import android.content.Context
import com.yugioh.android.utils.ConfigUtils

object Config {

    private val KEY_FONT_SIZE = "key_font_size"
    private val KEY_ASSIGNED_CARD = "key_assigned_card"

    fun cfgGetFontSize(context: Context): Int = ConfigUtils.getIntConfig(context, KEY_FONT_SIZE, 15)!!

    fun cfgSetFontSize(context: Context, value: Int) = ConfigUtils.setIntConfig(context, KEY_FONT_SIZE, value)

    fun cfgGetAssignedCard(context: Context): Boolean = ConfigUtils.getBooleanConfig(context, KEY_ASSIGNED_CARD, true)!!

    fun cfgSetAssignedCard(context: Context, value: Boolean) = ConfigUtils.setBooleanConfig(context, KEY_ASSIGNED_CARD, value)

}
