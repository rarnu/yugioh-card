//
//  RegExUtils.swift
//  sfunctional
//
//  Created by rarnu on 2018/9/12.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

public class RegExUtils: NSObject {
    
    private static let regNumbers = [
        "^[0-9]*$",                                     // 数字
        "^([1-9][0-9]*)+(.[0-9]{1,2})?$",               // 非零开头的最多带两位小数的数字
        "^(\\-)?\\d+(\\.\\d{1,2})?$",                   // 带1-2位小数的正数或负数
        "^(\\-|\\+)?\\d+(\\.\\d+)?$",                   // 正数、负数、和小数
        "^[0-9]+(.[0-9]{2})?$",                         // 有两位小数的正实数
        "^[0-9]+(.[0-9]{1,3})?$",                       // 有1~3位小数的正实数
        "^[1-9]\\d*$",                                  // 非零的正整数
        "^-[1-9]\\d*$",                                 // 非零的负整数
        "^\\d+$",                                       // 非负整数
        "^-[1-9]\\d*|0$",                               // 非正整数
        "^\\d+(\\.\\d+)?$",                             // 非负浮点数
        "^((-\\d+(\\.\\d+)?)|(0+(\\.0+)?))$",           // 非正浮点数
        "^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$",         // 正浮点数
        "^-([1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*)$",      // 负浮点数
        "^(-?\\d+)(\\.\\d+)?$"                          // 浮点数
    ]
    
    private static let regStrings = [
        "^[\\u4e00-\\u9fa5]{0,}$",                  // 汉字
        "^[A-Za-z0-9]+$",                           // 英文和数字
        "^[A-Za-z]+$",                              // 由26个英文字母组成的字符串
        "^[A-Z]+$",                                 // 由26个大写英文字母组成的字符串
        "^[a-z]+$",                                 // 由26个小写英文字母组成的字符串
        "^[a-z0-9A-Z_]+$",                          // 由数字、26个英文字母或者下划线组成的字符串
        "^[\\u4E00-\\u9FA5A-Za-z0-9_]+$",           // 中文、英文、数字包括下划线
        "^[\\u4E00-\\u9FA5A-Za-z0-9]+$",            // 中文、英文、数字但不包括下划线等符号
        "[^%&',;=?$\\x22]+",                        // 可以输入含有^%&',;=?$\"等字符
        "[^~\\x22]+"                                // 含有~的字符
    
    ]
    
    private class func regexMatch(_ str: String, _ regex: String) -> Bool {
        let r = NSPredicate(format: "SELF MATCHES %@", regex)
        return r.evaluate(with: str)
    }
    
    public class func isStringReg(_ str: String, _ type: Int) -> Bool {
        return regexMatch(str, regStrings[type])
    }
    
    public class func isNumberReg(_ str: String, _ type: Int) -> Bool {
        return regexMatch(str, regNumbers[type])
    }
    
    public class func isEmail(_ str: String) -> Bool {
        return regexMatch(str, "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$")
    }
    
    public class func isPhoneNumber(_ str: String) -> Bool {
        return regexMatch(str, "^(\\(\\d{3,4}-)|\\d{3.4}-)?\\d{7,8}$")
    }
    
    public class func isCellPhoneNumber(_ str: String) -> Bool {
        return regexMatch(str, "^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$")
    }
    
    public class func isChinesePhoneNumber(_ str: String) -> Bool {
        return regexMatch(str, "\\d{3}-\\d{8}|\\d{4}-\\d{7}")
    }
    
    public class func isIdCardNumber(_ str: String) -> Bool {
        return regexMatch(str, "^\\d{15}|\\d{18}$")
    }
    
    public class func isShortIdCardNumber(_ str: String) -> Bool {
        return regexMatch(str, "^([0-9]){7,18}(x|X)?$")
    }
    
    public class func isUrl(_ str: String) -> Bool {
        return regexMatch(str, "[a-zA-z]+://[^\\s]*")
    }
    
    public class func isDomain(_ str: String) -> Bool {
        return regexMatch(str, "[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(/.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+/.?")
    }
    
    public class func isValidAccount(_ str: String) -> Bool {
        return regexMatch(str, "^[a-zA-Z][a-zA-Z0-9_]{5,31}$")
    }
    
    public class func isValidPassword(_ str: String) -> Bool {
        return regexMatch(str, "^[a-zA-Z]\\w{5,31}$")
    }
    
    public class func isStrongPassword(_ str: String) -> Bool {
        return regexMatch(str, "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,10}$")
    }
    
    public class func isDate(_ str: String) -> Bool {
        return regexMatch(str, "^\\d{4}-\\d{1,2}-\\d{1,2}")
    }
    
    public class func isValidXml(_ str: String) -> Bool {
        return regexMatch(str, "^([a-zA-Z]+-?)+[a-zA-Z0-9]+\\\\.[x|X][m|M][l|L]$")
    }
    
    public class func isBlankLine(_ str: String) -> Bool {
        return regexMatch(str, "\\n\\s*\\r")
    }
    
    public class func isValidHtml(_ str: String) -> Bool {
        return regexMatch(str, "<(\\S*?)[^>]*>.*?</\\1>|<.*? />")
    }
    
    public class func isValidQQNumber(_ str: String) -> Bool {
        return regexMatch(str, "[1-9][0-9]{4,}")
    }
    
    public class func isValidPostCode(_ str: String) -> Bool {
        return regexMatch(str, "[1-9]\\d{5}(?!\\d)")
    }
    
    public class func isValidIPAddress(_ str: String) -> Bool {
        return regexMatch(str, "((?:(?:25[0-5]|2[0-4]\\\\d|[01]?\\\\d?\\\\d)\\\\.){3}(?:25[0-5]|2[0-4]\\\\d|[01]?\\\\d?\\\\d))")
    }
}
