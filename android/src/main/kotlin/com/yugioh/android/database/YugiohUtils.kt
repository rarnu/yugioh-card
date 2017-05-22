package com.yugioh.android.database

import android.content.ContentUris
import android.content.Context
import android.database.Cursor
import android.util.Log
import com.yugioh.android.R
import com.yugioh.android.classes.CardInfo

import java.lang.reflect.Field
import java.lang.reflect.Method

object YugiohUtils {

    fun closeDatabase(context: Context) =
            context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, YugiohProvider.ACTIONID_CLOSEDATABASE.toLong()), null, null, null, null)


    fun newDatabase(context: Context) =
            context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, YugiohProvider.ACTIONID_NEWDATABASE.toLong()), null, null, null, null)


    fun getOneCard(context: Context, cardId: Int): CardInfo? {
        val cursor = context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, cardId.toLong()), null, null, null, null)
        var info: CardInfo? = null
        if (cursor != null) {
            cursor.moveToFirst()
            while (!cursor.isAfterLast) {
                try {
                    info = cursorToCardInfo(cursor)
                } catch (e: Exception) {
                }

                break
            }
            cursor.close()
        }
        return info
    }

    fun getLastCardId(context: Context): Int {
        val cursor = context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, YugiohProvider.ACTIONID_CARDCOUNT.toLong()), null, null, null, null)
        var count = 0
        if (cursor != null) {
            cursor.moveToFirst()
            while (!cursor.isAfterLast) {
                count = cursor.getInt(0)
                break
            }
            cursor.close()
        }
        return count
    }

    fun getDatabaseVersion(context: Context): Int {
        val c = context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, YugiohProvider.ACTIONID_VERSION.toLong()), null, null, null, null)
        var ver = -1
        if (c != null) {
            c.moveToFirst()
            while (!c.isAfterLast) {
                ver = c.getInt(c.getColumnIndex("ver"))
                c.moveToNext()
            }
            c.close()
        }
        return ver
    }

    fun getLatest100(context: Context): Cursor? =
            context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, YugiohProvider.ACTIONID_TOP100.toLong()), null, null, null, null)


    fun getCardNames(context: Context, cardName: String): Cursor {
        val where = "name like ? or oldName like ? or shortName like ?"
        val argStr = "%$cardName%"
        val args = arrayOf(argStr, argStr, argStr)
        return context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, YugiohProvider.ACTIONID_SEARCH.toLong()), arrayOf("_id", "name"), where, args, null)
    }

    fun getCards(context: Context, cardType: String, cardAttribute: String, cardLevel: Int, cardRace: String, cardName: String, cardEffect: String, cardAtk: String, cardDef: String, cardRare: String, cardBelongs: String, cardLimit: String, cardTunner: String, cardLink: Int, cardLinkArrow: List<String>?): Cursor {

        var argCnt = 0
        var where = "1=1"
        if (cardType != "") {
            where += " and sCardType like ?"
            argCnt++
        }
        if (cardType.contains(context.getString(R.string.link))) {
            if (cardLink != 0) {
                where += " and link = ?"
                argCnt++
            }
            if (cardLinkArrow != null) {
                where += " and ("
                for (s in cardLinkArrow) {
                    where += "linkArrow like ? or "
                    argCnt++
                }
                where = where.substring(0, where.length - 3)
                where += ")"
            }
        }
        if (cardTunner != "") {
            if (cardType.contains(context.getString(R.string.monster))) {
                where += " and CardDType like ?"
                argCnt++
            }
        }
        if (cardAttribute != "") {
            where += " and element=?"
            argCnt++
        }
        if (cardRace != "") {
            where += " and tribe=?"
            argCnt++
        }
        if (cardLevel != 0) {
            where += " and level=?"
            argCnt++
        }
        if (cardName != "") {
            where += " and (name like ? or japName like ? or enName like ? or oldName like ? or shortName like ?)"
            argCnt += 5

        }
        if (cardRare != "") {
            where += " and infrequence like ?"
            argCnt++
        }
        if (cardBelongs != "") {
            where += " and cardCamp=?"
            argCnt++
        }
        if (cardAtk != "") {
            if (isNumeric(cardAtk)) {
                where += " and atkValue=?"
            } else {
                where += " and atk=?"
            }
            argCnt++
        }
        if (cardDef != "") {
            if (isNumeric(cardDef)) {
                where += " and defValue=?"
            } else {
                where += " and def=?"
            }
            argCnt++
        }
        if (cardLimit != "") {
            where += " and ban=?"
            argCnt++
        }
        if (cardEffect != "") {
            where += " and effect like ?"
            argCnt++
        }

        val args = arrayOfNulls<String>(argCnt)
        var argId = 0
        if (cardType != "") {
            args[argId] = "%$cardType%"
            argId++
        }
        if (cardType.contains(context.getString(R.string.link))) {
            if (cardLink != 0) {
                args[argId] = "$cardLink"
                argId++
            }
            if (cardLinkArrow != null) {
                for (s in cardLinkArrow) {
                    args[argId] = "%$s%"
                    argId++
                }
            }
        }
        if (cardTunner != "") {
            if (cardType.contains(context.getString(R.string.monster))) {
                args[argId] = "%$cardTunner%"
                argId++
            }
        }
        if (cardAttribute != "") {
            args[argId] = cardAttribute
            argId++
        }
        if (cardRace != "") {
            args[argId] = cardRace
            argId++
        }
        if (cardLevel != 0) {
            args[argId] = cardLevel.toString()
            argId++
        }
        if (cardName != "") {
            args[argId] = "%$cardName%"
            argId++
            args[argId] = "%$cardName%"
            argId++
            args[argId] = "%$cardName%"
            argId++
            args[argId] = "%$cardName%"
            argId++
            args[argId] = "%$cardName%"
            argId++
        }

        if (cardRare != "") {
            args[argId] = "%$cardRare%"
            argId++
        }

        if (cardBelongs != "") {
            args[argId] = cardBelongs
            argId++
        }

        if (cardAtk != "") {
            args[argId] = cardAtk
            argId++
        }
        if (cardDef != "") {
            args[argId] = cardDef
            argId++
        }
        if (cardLimit != "") {
            args[argId] = cardLimit
            argId++
        }

        if (cardEffect != "") {
            args[argId] = "%$cardEffect%"
            argId++
        }
        var LogArg = ""
        for (l in args) {
            LogArg += l + ", "
        }
        return context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, YugiohProvider.ACTIONID_SEARCH.toLong()), arrayOf("_id", "name", "sCardType"), where, args, null)

    }

    fun getBannedCards(context: Context): Cursor {

        val where = "ban=?"
        val args = arrayOf(context.resources.getString(R.string.card_banned_pure))
        val sort = "sCardType asc"

        return context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, YugiohProvider.ACTIONID_SEARCH.toLong()), arrayOf("_id", "name", "sCardType"), where, args, sort)

    }

    fun getLimit1Cards(context: Context): Cursor {
        val where = "ban=?"
        val args = arrayOf(context.resources.getString(R.string.card_limit1_pure))
        val sort = "sCardType asc"

        return context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, YugiohProvider.ACTIONID_SEARCH.toLong()), arrayOf("_id", "name", "sCardType"), where, args, sort)
    }

    fun getLimit2Cards(context: Context): Cursor {
        val where = "ban=?"
        val args = arrayOf(context.resources.getString(R.string.card_limit2_pure))
        val sort = "sCardType asc"

        return context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, YugiohProvider.ACTIONID_SEARCH.toLong()), arrayOf("_id", "name", "sCardType"), where, args, sort)
    }

    fun getAssignedCards(context: Context, union: String): Cursor {
        val where = "_id in ($union)"
        return context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, YugiohProvider.ACTIONID_SEARCH.toLong()), arrayOf("_id", "name", "sCardType"), where, null, null)
    }

    fun getCardsViaIds(context: Context, ids: IntArray): Cursor {
        var idList = ""
        for (i in ids.indices) {
            idList += "${ids[i]},"
        }
        idList = idList.substring(0, idList.length - 1)
        val where = "_id in ($idList)"
        return context.contentResolver.query(ContentUris.withAppendedId(YugiohProvider.CONTENT_URI, YugiohProvider.ACTIONID_SEARCH.toLong()), arrayOf("_id", "name", "sCardType"), where, null, null)
    }

    fun cursorToCardInfo(c: Cursor): CardInfo {

        val info = CardInfo()
        try {
            with(c) {
                with (info) {
                    id = getInt(getColumnIndex("_id"))
                    japName = getString(getColumnIndex("japName"))
                    name = getString(getColumnIndex("name"))
                    enName = getString(getColumnIndex("enName"))
                    sCardType = getString(getColumnIndex("sCardType"))
                    cardDType = getString(getColumnIndex("cardDType"))
                    tribe = getString(getColumnIndex("tribe"))
                    `package` = getString(getColumnIndex("package"))
                    element = getString(getColumnIndex("element"))
                    level = getInt(getColumnIndex("level"))
                    infrequence = getString(getColumnIndex("infrequence"))
                    atkValue = getInt(getColumnIndex("atkValue"))
                    atk = getString(getColumnIndex("atk"))
                    defValue = getInt(getColumnIndex("defValue"))
                    def = getString(getColumnIndex("def"))
                    effect = getString(getColumnIndex("effect"))
                    ban = getString(getColumnIndex("ban"))
                    cheatcode = getString(getColumnIndex("cheatcode"))
                    adjust = getString(getColumnIndex("adjust"))
                    cardCamp = getString(getColumnIndex("cardCamp"))
                    oldName = getString(getColumnIndex("oldName"))
                    shortName = getString(getColumnIndex("shortName"))
                    pendulumL = getInt(getColumnIndex("pendulumL"))
                    pendulumR = getInt(getColumnIndex("pendulumR"))
                    link = getInt(getColumnIndex("link"))
                    linkArrow = getString(getColumnIndex("linkArrow"))
                }
            }
        } catch (e: Exception) {

        }
        return info
    }

    private fun isNumeric(str: String): Boolean = str.matches("\\d*".toRegex())

}
