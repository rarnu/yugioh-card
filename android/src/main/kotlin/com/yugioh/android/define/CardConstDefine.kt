package com.yugioh.android.define

object CardConstDefine {

    const val DEFID_CARDRACE = 1
    const val DEFID_CARDBELONGS = 2
    const val DEFID_CARDTYPE = 3
    const val DEFID_CARDATTRITUBE = 4
    const val DEFID_CARDLEVEL = 5
    const val DEFID_CARDRARE = 6
    const val DEFID_CARDLIMIT = 7
    const val DEFID_CARDTUNNER = 8

    val cardRace: MutableList<String>
        get() = getDefine(CardRace)

    val cardBelongs: MutableList<String>
        get() = getDefine(CardBelongs)

    val cardType: MutableList<String>
        get() = getDefine(CardType)

    val cardAttribute: MutableList<String>
        get() = getDefine(CardAttribute)

    val cardLevel: MutableList<String>
        get() = getDefine(CardLevel)

    val cardCare: MutableList<String>
        get() = getDefine(CardRare)

    val cardLimit: MutableList<String>
        get() = getDefine(CardLimit)

    val cardTunner: MutableList<String>
        get() = getDefine(CardTunner)

    val linkArrow: MutableList<String>
        get() = getDefine(LinkArrow)

    private fun getDefine(def: Array<String>): MutableList<String> = def.toMutableList()

    private val CardRace = arrayOf("战士", "不死", "恶魔", "兽", "兽战士", "恐龙", "鱼", "机械", "水", "天使", "魔法师", "炎", "雷", "爬虫类", "植物", "昆虫", "岩石", "海龙", "鸟兽", "龙", "念动力", "幻龙", "电子界", "幻神兽", "创造神")

    private val CardBelongs = arrayOf("OCG、TCG", "OCG", "TCG")

    private val CardType = arrayOf("怪兽", "通常怪兽", "效果怪兽", "同调怪兽", "融合怪兽", "仪式怪兽", "XYZ怪兽", "连接怪兽", "魔法", "通常魔法", "场地魔法", "速攻魔法", "装备魔法", "仪式魔法", "永续魔法", "陷阱", "通常陷阱", "反击陷阱", "永续陷阱")

    private val CardAttribute = arrayOf("地", "水", "炎", "风", "光", "暗", "神")

    private val CardLevel = arrayOf("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")

    private val CardRare = arrayOf("平卡N", "银字R", "黄金GR", "平罕NR", "面闪SR", "金字UR", "爆闪PR", "全息HR", "鬼闪GHR", "平爆NPR", "红字RUR", "斜碎SCR", "银碎SER", "金碎USR", "立体UTR")

    private val CardLimit = arrayOf("无限制", "禁止卡", "限制卡", "准限制卡", "观赏卡")

    private val CardTunner = arrayOf("卡通", "灵魂", "同盟", "调整", "二重", "反转", "灵摆")

    private val LinkArrow = arrayOf("↙", "↓", "↘", "←", "", "→", "↖", "↑", "↗")
}
