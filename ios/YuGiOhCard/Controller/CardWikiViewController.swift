//
//  CardWikiViewController.swift
//  YuGiOhCard
//
//  Created by rarnu on 5/29/17.
//  Copyright © 2017 rarnu. All rights reserved.
//

import UIKit

class CardWikiViewController: UIViewController, HttpUtilsDelegate {

    @IBOutlet var wvWiki: UIWebView?
    var card: CardItem?
    var inited = false
    var 🐱 = "666"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inited = false
        self.card = (self.tabBarController! as! CardViewController).card
        let url = String(format: URL_CARD_WIKI, self.card!._id)
        let hu = HttpUtils()
        hu.tag = 1
        hu.delegate = self
        hu.get(url: url)
    }
    
    @objc func handleWikiData(data: Data) {
        self.wvWiki?.load(data, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: NSURL(string: BASE_OCG_URL)! as URL)
    }

    func httpUtils(httpUtils: HttpUtils, receivedData data: NSData?) {
        if (data != nil) {
            var str = NSString(data: data! as Data, encoding:String.Encoding.utf8.rawValue)!
            let start = str.range(of: "<article class=\"detail\">")
            let sEnd = str.range(of: "</article>", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(start.location, str.length - start.location - start.length))
            str = str.substring(with: NSMakeRange(
                start.location,
                sEnd.location - start.location)) as NSString
            let startPre = str.range(of: "<pre>")
            var pre = str.substring(with: NSMakeRange(startPre.location, str.range(of: "</pre>", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(startPre.location, str.length - startPre.location)).location - startPre.location)) as NSString
            pre = pre.replacingOccurrences(of: "\n", with: "<br>").replacingOccurrences(of: "<pre>", with: "<p>") as NSString
            pre = pre.appending("</p>") as NSString
            str = str.substring(from: str.range(of: "</pre>").location + 6) as NSString
            str = NSString(format: "<!DOCTYPE HTML><html class=\"no-js\" lang=\"zh-CN\" dir=\"ltr\"><head><meta http-equiv=\"X-UA-Compatible\" content=\"edge\" /><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><link rel=\"stylesheet\" href=\"http://static.ourocg.cn/themes/styles/styles.css\"><style>h3 {border-bottom:  3px solid #ADD8E6;border-top:     1px solid #ADD8E6;    border-left:   10px solid #ADD8E6;border-right:   5px solid #ADD8E6;  color:white;background-color:transparent;padding:.3em;margin:5px 0px .5em 0px;}</style></head><body style=\"color:white\"><article class=\"content\"><article class=\"detail\">%@<h3 id=\"content_1_0\">情报</h3>%@</article></article></body></html>", pre, str)
            str = replaceALink(str)
            let dt = str.data(using: String.Encoding.utf8.rawValue)
            self.performSelector(onMainThread: #selector(handleWikiData(data:)), with: dt, waitUntilDone: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (!inited) {
            inited = true
            for temp in self.view.subviews {
                if (temp is UIWebView) {
                    UIUtils.scaleComponent(view: temp)
                }
            }
        }
    }
    
    func replaceALink(_ s: NSString) -> NSString {
        var s = s
        while s.range(of: "<a href").location != NSNotFound {
            var p = s.range(of: "<a href")
            let pEnd = s.range(of: ">", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(p.location, s.length - p.location))
            s = s.substring(with: NSMakeRange(0, p.location)).appending("<font color='#ADD8E6'>").appending(s.substring(from: pEnd.location + 1)) as NSString
            p = s.range(of: "</a>")
            s = s.substring(with: NSMakeRange(0, p.location)).appending("</font>").appending(s.substring(from: p.location + 4)) as NSString
        }
        return s
    }
    
    
    

}
