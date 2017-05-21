package com.yugioh.android.define

object NetworkDefine {

    val BASE_URL = "http://rarnu.xyz/yugioh/"
    val UPDATE_URL = BASE_URL + "update.php"
    val UPDATE_PARAM_FMT = "ver=%d&cardid=%d&dbver=%d&os=a"
    val FEEDBACK_URL = BASE_URL + "feedback.php"
    val FEEDBACK_PARAM_FMT = "id=%s&email=%s&text=%s&appver=%d&osver=%d"

    val RECOMMAND_URL = BASE_URL + "get_recommand.php"
    val RECOMMAND_IMAGE_URL = BASE_URL + "recommand/"

    val URL_APK = BASE_URL + "download/YuGiOhCard.apk"
    val URL_DATA = BASE_URL + "download/yugioh.zip"

    val URL_CARD_IMAGE_FMT = "http://p.ocgsoft.cn/%d.jpg"
    val URL_OCGSOFT_BASE = "https://api.ourocg.cn/"
    val URL_OCGSOFT_GET_PACKAGE = URL_OCGSOFT_BASE + "Package/list"
    val URL_OCGSOFT_GET_PACKAGE_CARD = URL_OCGSOFT_BASE + "Package/card/packid/%s"

    val URL_UPDATE_LOG = BASE_URL + "update.txt"
    val URL_GITHUB = "https://github.com/rarnu/root-tools/tree/master/YGOCard"

}
