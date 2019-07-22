@file:Suppress("DuplicatedCode")

package com.rarnu.ygo.server.card

data class PackageInfo2(
    var season: String = "",
    var url: String = "",
    var name: String = "",
    var abbr: String = ""
)

data class LimitInfo2(
    var limit: Int = 0,
    var color: String = "",
    var hashid: String = "",
    var name: String = ""
)

data class CardPackInfo2(
    var url: String = "",
    var name: String = "",
    var date: String = "",
    var abbr: String = "",
    var rare: String = ""
)

data class CardDetail2(
    var name: String = "",
    var japname: String = "",
    var enname: String = "",
    var cardtype: String = "",
    var password: String = "",
    var limit: String = "",
    var belongs: String = "",
    var rare: String = "",
    var pack: String = "",
    var effect: String = "",
    var race: String = "",
    var element: String = "",
    var level: String = "",
    var atk: String = "",
    var def: String = "",
    var link: String = "",
    var linkarrow: String = "",
    var packs: Array<CardPackInfo2> = arrayOf(),
    var adjust: String = "",
    var wiki: String = "",
    var imageId: Int = -1
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false
        other as CardDetail2
        if (name != other.name) return false
        if (japname != other.japname) return false
        if (enname != other.enname) return false
        if (cardtype != other.cardtype) return false
        if (password != other.password) return false
        if (limit != other.limit) return false
        if (belongs != other.belongs) return false
        if (rare != other.rare) return false
        if (pack != other.pack) return false
        if (effect != other.effect) return false
        if (race != other.race) return false
        if (element != other.element) return false
        if (level != other.level) return false
        if (atk != other.atk) return false
        if (def != other.def) return false
        if (link != other.link) return false
        if (linkarrow != other.linkarrow) return false
        if (!packs.contentEquals(other.packs)) return false
        if (adjust != other.adjust) return false
        if (wiki != other.wiki) return false
        if (imageId != other.imageId) return false

        return true
    }

    override fun hashCode(): Int {
        var result = name.hashCode()
        result = 31 * result + japname.hashCode()
        result = 31 * result + enname.hashCode()
        result = 31 * result + cardtype.hashCode()
        result = 31 * result + password.hashCode()
        result = 31 * result + limit.hashCode()
        result = 31 * result + belongs.hashCode()
        result = 31 * result + rare.hashCode()
        result = 31 * result + pack.hashCode()
        result = 31 * result + effect.hashCode()
        result = 31 * result + race.hashCode()
        result = 31 * result + element.hashCode()
        result = 31 * result + level.hashCode()
        result = 31 * result + atk.hashCode()
        result = 31 * result + def.hashCode()
        result = 31 * result + link.hashCode()
        result = 31 * result + linkarrow.hashCode()
        result = 31 * result + packs.contentHashCode()
        result = 31 * result + adjust.hashCode()
        result = 31 * result + wiki.hashCode()
        result = 31 * result + imageId
        return result
    }
}

data class CardInfo2(
    var cardid: Int = 0,
    var hashid: String = "",
    var name: String = "",
    var japname: String = "",
    var enname: String = "",
    var cardtype: String = ""
)

data class SearchResult2(
    var data: Array<CardInfo2> = arrayOf(),
    var page: Int = 0,
    var pageCount: Int = 0) {

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false
        other as SearchResult2
        if (!data.contentEquals(other.data)) return false
        if (page != other.page) return false
        if (pageCount != other.pageCount) return false
        return true
    }

    override fun hashCode(): Int {
        var result = data.contentHashCode()
        result = 31 * result + page
        result = 31 * result + pageCount
        return result
    }
}

data class HotCard2(
    var hashid: String = "",
    var name: String = ""
)

data class HotPack2(
    var packid: String = "",
    var name: String = ""
)

data class Hotest2(
    val search: Array<String> = arrayOf(),
    var card: Array<HotCard2> = arrayOf(),
    var pack: Array<HotPack2> = arrayOf()) {

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false
        other as Hotest2
        if (!search.contentEquals(other.search)) return false
        if (!card.contentEquals(other.card)) return false
        if (!pack.contentEquals(other.pack)) return false
        return true
    }

    override fun hashCode(): Int {
        var result = search.contentHashCode()
        result = 31 * result + card.contentHashCode()
        result = 31 * result + pack.contentHashCode()
        return result
    }
}