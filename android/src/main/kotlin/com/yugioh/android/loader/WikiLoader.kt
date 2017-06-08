package com.yugioh.android.loader

import android.content.Context
import android.util.Log
import com.rarnu.base.app.BaseClassLoader
import com.rarnu.base.utils.HttpMethod
import com.rarnu.base.utils.HttpUtils
import com.rarnu.base.utils.http
import com.yugioh.android.define.NetworkDefine

/**
 * Created by rarnu on 5/29/17.
 */
class WikiLoader(context: Context): BaseClassLoader<String>(context) {

    var cardId = 0

    override fun loadInBackground(): String? {
        var s = http {
            url = String.format(NetworkDefine.URL_WIKI_FMT, cardId)
            method = HttpMethod.GET
        }!!
        val start = s.indexOf("<article class=\"detail\">")
        s = s.substring(start, s.indexOf("</article>", start))
        val startPre = s.indexOf("<pre>")
        var pre = s.substring(startPre, s.indexOf("</pre>", startPre))
        pre = pre.replace("\n", "<br>").replace("<pre>", "<p>")
        pre += "</p>"
        s = s.substring(s.indexOf("</pre>") + 6)
        s = "<!DOCTYPE HTML><html class=\"no-js\" lang=\"zh-CN\" dir=\"ltr\"><head><meta http-equiv=\"X-UA-Compatible\" content=\"edge\" /><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><link rel=\"stylesheet\" href=\"http://static.ourocg.cn/themes/styles/styles.css\"><style>h3 {border-bottom:  3px solid #8987B9;border-top:     1px solid #8987B9;    border-left:   10px solid #8987B9;border-right:   5px solid #8987B9;  color:inherit;background-color:#efefef;padding:.3em;margin:5px 0px .5em 0px;}</style></head><body><article class=\"content\"><article class=\"detail\">$pre<h3 id=\"content_1_0\">情报</h3>$s</article></article></body></html>"
        s = replaceALink(s)
        return s
    }

    private fun replaceALink(s: String): String {
        var s = s
        var p: Int
        var pEnd: Int
        while (s.indexOf("<a href") >= 0) {
            p = s.indexOf("<a href")
            pEnd = s.indexOf(">", p)
            s = s.substring(0, p) + "<font color=blue" + s.substring(pEnd)
            p = s.indexOf("</a>")
            s = s.substring(0, p) + "</font>" + s.substring(p + 4)
        }
        return s
    }
}

