package com.rarnu.yugioh.card.data

import org.json.JSONObject

data class CardListInfo(val id: Int, val hashId: String, val name: String, val japname: String, val enname: String, val cardtype: String) {
    companion object {
        fun fromJson(json: JSONObject) = with(json) {
            CardListInfo(
                    getInt("id"),
                    getString("hashid"),
                    getString("name"),
                    getString("japname"),
                    getString("enname"),
                    getString("cardtype")
            )
        }

    }
}