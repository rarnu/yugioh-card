package com.yugioh.android.utils

import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.os.Handler
import android.os.Message
import com.rarnu.base.utils.FileUtils
import com.yugioh.android.CardInfoActivity
import com.yugioh.android.classes.CardItems
import com.yugioh.android.database.YugiohUtils
import com.yugioh.android.define.PathDefine
import kotlin.concurrent.thread

object MiscUtils {

    fun openCardDetail(context: Context, c: Cursor?, position: Int) {
        if (c != null) {
            c.moveToPosition(position)
            val cardId = c.getInt(0)
            val inCardInfo = Intent(context, CardInfoActivity::class.java)
            val info = YugiohUtils.getOneCard(context, cardId)
            inCardInfo.putExtra("cardinfo", info)
            context.startActivity(inCardInfo)
        }
    }

    /**
     * @param type 0:pack, 1:deck
     * *
     * @param id
     * *
     * @param h
     */
    fun loadCardsDataT(type: Int, id: String, refresh: Boolean, callback:(CardItems?) -> Unit) {
        thread {

            var items: CardItems? = null
            when (type) {
                0 -> if (refresh) {
                    items = YGOAPI.getPackageCards(id)
                    if (items != null) {
                        FileUtils.saveObjectToFile(items, String.format(PathDefine.PACK_ITEM, id))
                    } else {
                        items = FileUtils.loadObjetFromFile(String.format(PathDefine.PACK_ITEM, id)) as CardItems?
                    }
                } else {
                    items = FileUtils.loadObjetFromFile(String.format(PathDefine.PACK_ITEM, id)) as CardItems?
                    if (items == null) {
                        items = YGOAPI.getPackageCards(id)
                        if (items != null) {
                            FileUtils.saveObjectToFile(items, String.format(PathDefine.PACK_ITEM, id))
                        }
                    }
                }
                1 -> if (refresh) {
                    items = YGOAPI.getDeckCards(id)
                    if (items != null) {
                        FileUtils.saveObjectToFile(items, String.format(PathDefine.DECK_ITEM, id))
                    } else {
                        items = FileUtils.loadObjetFromFile(String.format(PathDefine.DECK_ITEM, id)) as CardItems?
                    }
                } else {
                    items = FileUtils.loadObjetFromFile(String.format(PathDefine.DECK_PATH, id)) as CardItems?
                    if (items == null) {
                        items = YGOAPI.getDeckCards(id)
                        if (items != null) {
                            FileUtils.saveObjectToFile(items, String.format(PathDefine.DECK_ITEM, id))
                        }
                    }
                }
            }
            if (items != null) {
                items.id = id
            }
            callback(items)
        }

    }
}
