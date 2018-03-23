package com.yugioh.android.define

object NetworkDefine {

    private const val BASE_URL = "http://rarnu.xyz/yugioh/"
    const val UPDATE_URL = BASE_URL + "update.php"
    const val UPDATE_PARAM_FMT = "ver=%d&cardid=%d&dbver=%d&os=a"
    const val FEEDBACK_URL = BASE_URL + "feedback.php"
    const val FEEDBACK_PARAM_FMT = "id=%s&email=%s&text=%s&appver=%d&osver=%d"

    const val RECOMMAND_URL = BASE_URL + "get_recommand.php"
    const val RECOMMAND_IMAGE_URL = BASE_URL + "recommand/"

    const val URL_APK = BASE_URL + "download/YuGiOhCard.apk"
    const val URL_DATA = BASE_URL + "download/yugioh.zip"

    const val URL_CARD_IMAGE_FMT = "http://p.ocgsoft.cn/%d.jpg"
    const val URL_WIKI_FMT = "http://www.ourocg.cn/Cards/Wiki-%d"
    private const val URL_OCGSOFT_BASE = "https://api.ourocg.cn/"
    const val URL_OCGSOFT_GET_PACKAGE = URL_OCGSOFT_BASE + "Package/list"
    const val URL_OCGSOFT_GET_PACKAGE_CARD = URL_OCGSOFT_BASE + "Package/card/packid/%s"

    const val URL_UPDATE_LOG = BASE_URL + "update.txt"
    const val URL_GITHUB = "https://github.com/rarnu/root-tools/tree/master/YGOCard"

}
