package com.yugioh.android.loader

import android.content.Context
import android.database.Cursor
import android.os.Bundle
import com.rarnu.base.app.BaseCursorLoader
import com.yugioh.android.database.YugiohUtils

class SearchLoader(context: Context, private var bn: Bundle?) : BaseCursorLoader(context) {

    fun setBundle(bn: Bundle) {
        this.bn = bn
    }

    override fun loadInBackground(): Cursor? {
        var cSearchResult: Cursor?
        if (bn!!.containsKey("ids")) {
            val ids = bn!!.getIntArray("ids")
            cSearchResult = YugiohUtils.getCardsViaIds(context, ids)
        } else {
            val cardType = bn!!.getString("cardType")
            val cardAttribute = bn!!.getString("cardAttribute")
            val cardLevel = bn!!.getInt("cardLevel")
            val cardRace = bn!!.getString("cardRace")
            val cardName = bn!!.getString("cardName")
            val cardEffect = bn!!.getString("cardEffect")
            val cardAtk = bn!!.getString("cardAtk")
            val cardDef = bn!!.getString("cardDef")
            val cardRare = bn!!.getString("cardRare")
            val cardBelongs = bn!!.getString("cardBelongs")
            val cardLimit = bn!!.getString("cardLimit")
            val cardTunner = bn!!.getString("cardTunner")
            val cardLink = bn!!.getInt("cardLink", 0)
            val cardLinkArrow = bn!!.getString("cardLinkArrow")
            val arrowArr = cardLinkArrow.split(",")
            cSearchResult = YugiohUtils.getCards(context, cardType, cardAttribute, cardLevel, cardRace, cardName, cardEffect, cardAtk, cardDef, cardRare, cardBelongs, cardLimit, cardTunner, cardLink, arrowArr)
        }
        return cSearchResult
    }


}
