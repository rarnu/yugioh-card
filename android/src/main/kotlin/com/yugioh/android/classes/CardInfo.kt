package com.yugioh.android.classes

import java.io.Serializable
import java.lang.reflect.Field
import java.lang.reflect.Method

class CardInfo : Serializable {

    var id = 0
    var japName = ""
    var name = ""
    var enName = ""
    var sCardType = ""
    var cardDType = ""
    var tribe = ""
    var `package` = ""
    var element = ""
    var level = 0
    var infrequence = ""
    var atkValue = 0
    var atk = ""
    var defValue = 0
    var def = ""
    var effect = ""
    var ban = ""
    var cheatcode = ""
    var adjust = ""
    var cardCamp = ""
    var oldName = ""
    var shortName = ""
    var pendulumL = 0
    var pendulumR = 0
    var link = 0
    var linkArrow = ""

}
