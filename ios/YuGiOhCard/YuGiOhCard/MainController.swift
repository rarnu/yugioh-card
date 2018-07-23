//
//  ViewController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/6/29.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import YGOAPI
import sfunctional
import TangramKit

class MainController: UIViewController, UITextFieldDelegate {

    var layMain: TGLinearLayout?
    var edtSearch: UITextField?
    var btnSearch: UIButton?
    var btnAdvSearch: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView(frame: CGRect(x: 8, y: 8, width: screenWidth() - 16, height: screenHeight() - 16))
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        self.view.addSubview(sv)
        layMain = TGLinearLayout(.vert)
        layMain?.tg_vspace = 0
        layMain?.tg_width.equal(100%)
        layMain?.tg_height.equal(.wrap).min(sv.tg_height, increment: 0)
        sv.addSubview(layMain!)
        let v = UIView()
        v.tg_width.equal(100%)
        v.tg_height.equal(45)
        layMain?.addSubview(v)
        edtSearch = UITextField(frame: CGRect(x: 0, y: 0, width: screenWidth() - 140, height: 36))
        edtSearch?.borderStyle = UITextBorderStyle.none
        edtSearch?.placeholder = "输入要搜索的关键字"
        edtSearch?.returnKeyType = UIReturnKeyType.done
        edtSearch?.delegate = self
        v.addSubview(edtSearch!)
        btnSearch = UIButton(type: UIButtonType.system)
        btnSearch?.frame = CGRect(x: screenWidth() - 128, y: 0, width: 40, height: 36)
        btnSearch?.setTitle("搜索", for: UIControlState.normal)
        v.addSubview(btnSearch!)
        btnAdvSearch = UIButton(type: UIButtonType.system)
        btnAdvSearch?.frame = CGRect(x: screenWidth() - 88, y: 0, width: 80, height: 36)
        btnAdvSearch?.setTitle("高级搜索", for: UIControlState.normal)
        v.addSubview(btnAdvSearch!)
        let line = UIView(frame: CGRect(x: 0, y: 36, width: screenWidth() - 16, height: 1))
        line.backgroundColor = UIColor.lightGray
        v.addSubview(line)
        let blank = UIView()
        blank.tg_width.equal(100%)
        blank.tg_height.equal(8)
        layMain?.addSubview(blank)
        // event
        btnSearch?.addTarget(self, action: #selector(btnSearchClicked(sender:)), for: UIControlEvents.touchDown)
        btnAdvSearch?.addTarget(self, action: #selector(btnAdvSearchClicked(sender:)), for: UIControlEvents.touchDown)
        loadHotest()
        
        Updater.checkUpdate(vc: self)
    }
    
    private func loadHotest() {
        func makeText(_ txt: String) {
            let lbl = UILabel()
            lbl.tg_width.equal(100%)
            lbl.tg_height.equal(.wrap)
            lbl.text = txt
            layMain?.addSubview(lbl)
            let v = UIView()
            v.tg_width.equal(100%)
            v.tg_height.equal(4)
            layMain?.addSubview(v)
        }
        
        func makeButton(_ txt: String) -> UIButton {
            let btn = UIButton(type: UIButtonType.system)
            btn.tg_width.equal(100%)
            btn.tg_height.equal(32)
            btn.setTitle(txt, for: UIControlState.normal)
            layMain?.addSubview(btn)
            return btn
        }
        
        func makeLine() {
            let v = UIView()
            v.tg_width.equal(100%)
            v.tg_height.equal(1)
            v.tg_vertMargin(8.0)
            v.backgroundColor = UIColor.lightGray
            layMain?.addSubview(v)
        }
        
        func makeLabel(txt: String, hash: String, sel: Selector) {
            let l = UIButton(type: UIButtonType.system)
            l.tg_width.equal(100%)
            l.tg_height.equal(32)
            l.setTitle(txt, for: UIControlState.normal)
            l.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            l.accessibilityValue = hash
            l.addTarget(self, action: sel, for: UIControlEvents.touchDown)
            layMain?.addSubview(l)
        }
        
        func makeKeyword(list: Array<String>) {
            var idx = 0
            var remain = list.count
            let w = (screenWidth() - 16) / 5
            while remain > 0 {
                let lay = TGLinearLayout(.horz)
                lay.tg_width.equal(100%)
                lay.tg_height.equal(32)
                var last = 0
                if (remain >= 5) {
                    last = idx + 5
                } else {
                    last = idx + remain
                }
                for i in idx ..< last {
                    let v = UIButton(type: UIButtonType.system)
                    v.tg_width.equal(w)
                    v.tg_height.equal(32)
                    v.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
                    v.setTitle(list[i], for: UIControlState.normal)
                    v.addTarget(self, action: #selector(btnKeywordClicked(sender:)), for: UIControlEvents.touchDown)
                    lay.addSubview(v)
                }
                if (remain >= 5) {
                    idx += 5
                    remain -= 5
                } else {
                    idx += remain
                    remain -= remain
                }
                layMain?.addSubview(lay)
            }
        }
        
        thread {
            let ret = YGOData.hostest()
            self.mainThread {
                if (ret != nil) {
                    makeText("热门搜索")
                    makeKeyword(list: ret!.search)
                    makeLine()
                    makeText("热门卡片")
                    for c in ret!.card {
                        makeLabel(txt: c.name, hash: c.hashid, sel: #selector(self.btnHotCardClicked(sender:)))
                    }
                    makeLine()
                    makeText("热门卡包")
                    for p in ret!.pack {
                        makeLabel(txt: p.name, hash: p.packid, sel: #selector(self.btnHotPackClicked(sender:)))
                    }
                    makeLine()
                }
                let btnHelp = makeButton("帮助")
                btnHelp.addTarget(self, action: #selector(self.btnHelpClicked(sender:)), for: UIControlEvents.touchDown)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func btnSearchClicked(sender: Any?) {
        // search clicked
        let key = edtSearch?.text
        if (key == nil || key == "") {
            self.view.toast(msg: "不能搜索空关键字")
            return
        }
        let c = vc(name: "cardlist") as! CardListController
        c.key = key!
        navigationController?.pushViewController(c, animated: true)
    }
    
    @objc func btnAdvSearchClicked(sender: Any?) {
        let c = vc(name: "search") as! SearchController
        navigationController?.pushViewController(c, animated: true)
    }
    
    @IBAction func btnLimitClicked(sender: Any?) {
        let c = vc(name: "limit") as! LimitController
        navigationController?.pushViewController(c, animated: true)
    }
    
    @IBAction func btnPackClicked(sender: Any?) {
        let c = vc(name: "pack") as! PackController
        navigationController?.pushViewController(c, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func btnKeywordClicked(sender: UIButton) {
        let c = vc(name: "cardlist") as! CardListController
        c.key = sender.currentTitle!
        navigationController?.pushViewController(c, animated: true)
    }
    
    @objc func btnHotCardClicked(sender: UIButton) {
        let hash = sender.accessibilityValue
        let name = sender.currentTitle
        let c = vc(name: "detail") as! CardDetailController
        c.cardname = name!
        c.hashid = hash!
        navigationController?.pushViewController(c, animated: true)
    }
    
    @objc func btnHotPackClicked(sender: UIButton) {
        let name = sender.currentTitle
        let url = sender.accessibilityValue
        let c = vc(name: "packdetail") as! PackDetailController
        c.name = name!
        c.url = url!
        navigationController?.pushViewController(c, animated: true)
    }
    
    @objc func btnHelpClicked(sender: UIButton) {
        let c = vc(name: "help") as! HelpController
        navigationController?.pushViewController(c, animated: true)
    }
}

