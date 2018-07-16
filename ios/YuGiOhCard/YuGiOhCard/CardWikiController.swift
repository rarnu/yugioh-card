//
//  CardWikiController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/5.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import TangramKit
import sfunctional

class CardWikiController: UIViewController {

    var wiki = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sv = UIScrollView(frame: CGRect(x: 8, y: 8, width: screenWidth() - 16, height: screenHeight() - 16))
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        self.view.addSubview(sv)
        let layMain = TGLinearLayout(.vert)
        layMain.tg_vspace = 0
        layMain.tg_width.equal(100%)
        layMain.tg_height.equal(.wrap).min(sv.tg_height, increment: 0)
        sv.addSubview(layMain)
        let tvWiki = UILabel()
        tvWiki.tg_width.equal(100%)
        tvWiki.tg_height.equal(.wrap)
        tvWiki.lineBreakMode = NSLineBreakMode.byWordWrapping
        tvWiki.numberOfLines = 0
        layMain.addSubview(tvWiki)
        
        let attrStr = try! NSAttributedString(data: wiki.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        tvWiki.attributedText = attrStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
