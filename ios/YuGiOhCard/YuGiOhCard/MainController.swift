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
    var laySearchKeyword: TGLinearLayout?
    var layHotCard: TGLinearLayout?
    var layLastPack: TGLinearLayout?
    
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
        edtSearch?.borderStyle = UITextField.BorderStyle.none
        edtSearch?.placeholder = "输入要搜索的关键字"
        edtSearch?.returnKeyType = UIReturnKeyType.done
        edtSearch?.delegate = self
        v.addSubview(edtSearch!)
        btnSearch = UIButton(type: UIButton.ButtonType.system)
        btnSearch?.frame = CGRect(x: screenWidth() - 128, y: 0, width: 40, height: 36)
        btnSearch?.setTitle("搜索", for: UIControl.State.normal)
        v.addSubview(btnSearch!)
        btnAdvSearch = UIButton(type: UIButton.ButtonType.system)
        btnAdvSearch?.frame = CGRect(x: screenWidth() - 88, y: 0, width: 80, height: 36)
        btnAdvSearch?.setTitle("高级搜索", for: UIControl.State.normal)
        v.addSubview(btnAdvSearch!)
        let line = UIView(frame: CGRect(x: 0, y: 36, width: screenWidth() - 16, height: 1))
        line.backgroundColor = UIColor.lightGray
        v.addSubview(line)
        let blank = UIView()
        blank.tg_width.equal(100%)
        blank.tg_height.equal(8)
        layMain?.addSubview(blank)
        // event
        btnSearch?.addTarget(self, action: #selector(btnSearchClicked(sender:)), for: UIControl.Event.touchDown)
        btnAdvSearch?.addTarget(self, action: #selector(btnAdvSearchClicked(sender:)), for: UIControl.Event.touchDown)
        
        //
        makeText("热门搜索")
        laySearchKeyword = makeLayout()
        makeLine()
        makeHotText("热门卡片")
        layHotCard = makeLayout()
        makeLine()
        makeText("热门卡包")
        layLastPack = makeLayout()
        makeLine()
        let btnHelp = makeButton("帮助")
        btnHelp.addTarget(self, action: #selector(self.btnHelpClicked(sender:)), for: UIControl.Event.touchDown)
        
        loadHotest()
        
        Updater.checkUpdate(vc: self)
    }
    
    func makeLayout() -> TGLinearLayout {
        let lay = TGLinearLayout(.vert)
        lay.tg_vspace = 0
        lay.tg_width.equal(100%)
        lay.tg_height.equal(.wrap)
        layMain?.addSubview(lay)
        return lay
    }
    
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
    
    func makeHotText(_ txt: String) {
        let lay = UIView()
        lay.tg_width.equal(100%)
        lay.tg_height.equal(30)
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        lbl.text = txt
        lay.addSubview(lbl)
        let change = UIButton(type: UIButton.ButtonType.system)
        change.setTitle("<换一批>", for: UIControl.State.normal)
        change.frame = CGRect(x: screenWidth() - 100, y: 0, width: 100, height: 30)
        change.addTarget(self, action: #selector(btnChangeHotClicked(sender:)), for: UIControl.Event.touchDown)
        lay.addSubview(change)
        
        layMain?.addSubview(lay)
        let v = UIView()
        v.tg_width.equal(100%)
        v.tg_height.equal(4)
        layMain?.addSubview(v)
    }
    
    func makeButton(_ txt: String) -> UIButton {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.tg_width.equal(100%)
        btn.tg_height.equal(32)
        btn.setTitle(txt, for: UIControl.State.normal)
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
    
    func makeLabel(lay: TGLinearLayout?, txt: String, hash: String, sel: Selector) {
        let l = UIButton(type: UIButton.ButtonType.system)
        l.tg_width.equal(100%)
        l.tg_height.equal(32)
        l.setTitle(txt, for: UIControl.State.normal)
        l.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        l.accessibilityValue = hash
        l.addTarget(self, action: sel, for: UIControl.Event.touchDown)
        lay?.addSubview(l)
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
                let v = UIButton(type: UIButton.ButtonType.system)
                v.tg_width.equal(w)
                v.tg_height.equal(32)
                v.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                v.setTitle(list[i], for: UIControl.State.normal)
                v.addTarget(self, action: #selector(btnKeywordClicked(sender:)), for: UIControl.Event.touchDown)
                lay.addSubview(v)
            }
            if (remain >= 5) {
                idx += 5
                remain -= 5
            } else {
                idx += remain
                remain -= remain
            }
            laySearchKeyword?.addSubview(lay)
        }
    }
    
    private func loadHotest() {
        laySearchKeyword?.tg_removeAllSubviews()
        layHotCard?.tg_removeAllSubviews()
        layLastPack?.tg_removeAllSubviews()
        thread {
            let ret = YGOData.hostest()
            self.mainThread {
                if (ret != nil) {
                    self.makeKeyword(list: ret!.search)
                    for c in ret!.card {
                        self.makeLabel(lay: self.layHotCard, txt: c.name, hash: c.hashid, sel: #selector(self.btnHotCardClicked(sender:)))
                    }
                    for p in ret!.pack {
                        self.makeLabel(lay: self.layLastPack, txt: p.name, hash: p.packid, sel: #selector(self.btnHotPackClicked(sender:)))
                    }
                }
            }
        }
    }
    
    @objc func btnChangeHotClicked(sender: Any?) {
        loadHotest()
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

