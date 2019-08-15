//
//  DeckListController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2019/8/15.
//  Copyright © 2019 rarnu. All rights reserved.
//

import UIKit
import commonios
import TangramKit
import YGOAPI2


class DeckListController: UIViewController {
    
    
    private var layMain: TGLinearLayout!
    private var layTheme: TGLinearLayout!
    private var layCategory: TGLinearLayout!
    private var listTheme: [DeckTheme]!
    private var listCategory: [DeckCategory]!
    
    func makeLayout() -> TGLinearLayout {
        let lay = TGLinearLayout(.vert)
        lay.tg_vspace = 0
        lay.tg_width.equal(100%)
        lay.tg_height.equal(.wrap)
        layMain.addSubview(lay)
        return lay
    }

    func makeLine() {
        let v = UIView()
        v.tg_width.equal(100%)
        v.tg_height.equal(1)
        v.tg_vertMargin(16.0)
        v.backgroundColor = UIColor.darkGray
        layMain.addSubview(v)
    }
    
    func makeDeckCategoryLabel(_ list: [DeckCategory]) {
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
                v.addTarget(self, action: #selector(btnCategoryClicked(sender:)), for: UIControl.Event.touchDown)
                lay.addSubview(v)
            }
            if (remain >= 3) {
                idx += 3
                remain -= 3
            } else {
                idx += remain
                remain -= remain
            }
            layTheme.addSubview(lay)
        }
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
            layCategory.addSubview(lay)
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
        layTheme = makeLayout()
        makeLine()
        layCategory = makeLayout()
        
        YGOData2.deckCategory { list in
            self.listCategory = list
            mainThread { self.makeDeckCategoryLabel(self.listCategory) }
        }
        YGOData2.deckTheme { list in
            self.listTheme = list
            mainThread { self.makeDeckThemeLabel(self.listTheme) }
        }
    }
    
    @objc func btnCategoryClicked(sender: UIButton) {
        let item = listCategory.find { it in
            it.name == sender.titleLabel?.text
        }
        if (item != nil) {
            let hash = item!.guid
            let c = vc(name: "deckincategory") as! DeckInCategoryController
            c.deckhash = hash
            navigationController?.pushViewController(c, animated: true)
        }
    }
    
    @objc func btnThemeClicked(sender: UIButton) {
        let item = listTheme.find { it in
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
