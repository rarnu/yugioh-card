import UIKit

let BASE_OCG_URL = "https://api.ourocg.cn/"
let URL_PACKAGES = "\(BASE_OCG_URL)Package/list"
let URL_PACAKGE_CARD = "\(BASE_OCG_URL)Package/card/packid/%@"
let URL_CARD_IMAGE = "http://p.ocgsoft.cn/%ld.jpg"
let BASE_YUGIOH_URL = "http://rarnu.7thgen.info/yugioh/"
let URL_FEEDBACK = "\(BASE_YUGIOH_URL)feedback.php"
let PARAM_FEEDBACK = "id=%@&email=%@&text=%@&appver=%@&osver=%@"
let URL_UPDATE = "\(BASE_YUGIOH_URL)update.php"
let PARAM_UPDATE = "ver=%d&cardid=%d&dbver=%d"
let URL_FILE_DATABASE = "\(BASE_YUGIOH_URL)download/yugioh.zip"
let URL_UPDATE_LOG = "\(BASE_YUGIOH_URL)update.ios.txt"
let ZIP_NAME = "yugioh.zip"
