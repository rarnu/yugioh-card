//
//  DeckInCategoryController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2019/8/15.
//  Copyright © 2019 rarnu. All rights reserved.
//

import UIKit
import commonios
import TangramKit
import YGOAPI2

class DeckInCategoryController: UIViewController {

    var deckhash = ""
    private var layMain: TGLinearLayout!
    private var layDeck: TGLinearLayout!
    private var listDeck: [DeckTheme]!
    
    func makeLayout() -> TGLinearLayout {
        let lay = TGLinearLayout(.vert)
        lay.tg_vspace = 0
        lay.tg_width.equal(100%)
        lay.tg_height.equal(.wrap)
        layMain.addSubview(lay)
        return lay
    }
    
    func makeDeckThemeLabel(_ list: [DeckTheme]) {
        var idx = 0
        var remain = list.count
        let w = (screenWidth() - 16) / 3
        while remain > 0 {
            let lay = TGLinearLayout(.horz)
            lay.tg_width.equal(100%)
            lay.tg_height.equal(32)
            var last = 0
            if (remain >= 3) {
                last = idx + 3
            } else {
                last = idx + remain
            }
            for i in idx ..< last {
                let v = UIButton(type: UIButton.ButtonType.system)
                v.tg_width.equal(w)
                v.tg_height.equal(32)
                v.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                v.setTitle(list[i].name, for: UIControl.State.normal)
                v.addTarget(self, action: #selector(btnThemeClicked(sender:)), for: UIControl.Event.touchDown)
                lay.addSubview(v)
            }
            if (remain >= 3) {
                idx += 3
                remain -= 3
            } else {
                idx += remain
                remain -= remain
            }
            layDeck.addSubview(lay)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sv = UIScrollView(frame: CGRect(x: 8, y: 8, width: screenWidth() - 16, height: screenHeight() - 16))
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        self.view.addSubview(sv)
        layMain = TGLinearLayout(.vert) ~>> {
            $0.tg_vspace = 0
            $0.tg_width.equal(100%)
            $0.tg_height.equal(.wrap).min(sv.tg_height, increment: 0)
            return $0
        }
        sv.addSubview(layMain)
        layDeck = makeLayout()
        
        YGOData2.deckInCategory(self.deckhash) { list in
            self.listDeck = list
            mainThread { self.makeDeckThemeLabel(self.listDeck) }
        }
    }
    
    @objc func btnThemeClicked(sender: UIButton) {
        let item = listDeck.find { it in
            it.name == sender.titleLabel?.text
        }
        if (item != nil) {
            let code = item!.code
            let c = vc(name: "deckdetail") as! DeckController
            c.deckcode = code
            navigationController?.pushViewController(c, animated: true)
        }
    }

}
