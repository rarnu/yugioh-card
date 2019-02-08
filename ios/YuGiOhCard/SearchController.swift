//
//  SearchController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/10.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import sfunctional
import TangramKit

class SearchController: UIViewController, UITextFieldDelegate {

    var cardtype = ""
    
    var sv: UIScrollView?
    var layMain: TGLinearLayout?
    
    var btnTypeMon: UIButton?
    var btnTypeMagic: UIButton?
    var btnTypeTrap: UIButton?
    var edtEffect: UITextField?
    
    var layMonster: TGLinearLayout?
    var layMagic: TGLinearLayout?
    var layTrap: TGLinearLayout?
    
    var btnMtNormal: UIButton?
    var btnMtEquip: UIButton?
    var btnMtQuick: UIButton?
    var btnMtCont: UIButton?
    var btnMtField: UIButton?
    var btnMtRitual: UIButton?
    
    var btnTtNormal: UIButton?
    var btnTtCont: UIButton?
    var btnTtCounter: UIButton?
    
    var btnMonEleLight: UIButton?
    var btnMonEleDark: UIButton?
    var btnMonEleFire: UIButton?
    var btnMonEleWater: UIButton?
    var btnMonEleEarth: UIButton?
    var btnMonEleWind: UIButton?
    var btnMonEleGod: UIButton?
    
    var btnMonTypeNormal: UIButton?
    var btnMonTypeEffect: UIButton?
    var btnMonTypeRitual: UIButton?
    var btnMonTypeFusion: UIButton?
    var btnMonTypeSync: UIButton?
    var btnMonTypeXyz: UIButton?
    var btnMonTypeToon: UIButton?
    var btnMonTypeUnion: UIButton?
    var btnMonTypeSpirit: UIButton?
    var btnMonTypeTuner: UIButton?
    var btnMonTypeDouble: UIButton?
    var btnMonTypePendulum: UIButton?
    var btnMonTypeReverse: UIButton?
    var btnMonTypeSS: UIButton?
    var btnMonTypeLink: UIButton?
    
    var btnMonRaceWater: UIButton?
    var btnMonRaceBeast: UIButton?
    var btnMonRaceBW: UIButton?
    var btnMonRaceCreation: UIButton?
    var btnMonRaceDino: UIButton?
    var btnMonRaceGod: UIButton?
    var btnMonRaceDragon: UIButton?
    
    var btnMonRaceAngel: UIButton?
    var btnMonRaceDemon: UIButton?
    var btnMonRaceFish: UIButton?
    var btnMonRaceInsect: UIButton?
    var btnMonRaceMachine: UIButton?
    var btnMonRacePlant: UIButton?
    var btnMonRaceCy: UIButton?
    
    var btnMonRaceFire: UIButton?
    var btnMonRaceClaim: UIButton?
    var btnMonRaceRock: UIButton?
    var btnMonRaceSD: UIButton?
    var btnMonRaceMagician: UIButton?
    var btnMonRaceThunder: UIButton?
    var btnMonRaceWarrior: UIButton?
    
    var btnMonRaceWB: UIButton?
    var btnMonRaceUndead: UIButton?
    var btnMonRaceDD: UIButton?
    var btnMonRaceCyber: UIButton?
    
    var edtLevel: UITextField?
    var edtScale: UITextField?
    var edtAtk: UITextField?
    var edtDef: UITextField?
    var edtLink: UITextField?
    
    var btnLink7: UIButton?
    var btnLink8: UIButton?
    var btnLink9: UIButton?
    var btnLink4: UIButton?
    var btnLink5: UIButton?
    var btnLink6: UIButton?
    var btnLink1: UIButton?
    var btnLink2: UIButton?
    var btnLink3: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sv = UIScrollView(frame: CGRect(x: 8, y: 8, width: screenWidth() - 16, height: screenHeight() - 16))
        sv?.showsVerticalScrollIndicator = false
        sv?.showsHorizontalScrollIndicator = false
        self.view.addSubview(sv!)
        layMain = TGLinearLayout(.vert)
        layMain?.tg_vspace = 0
        layMain?.tg_width.equal(100%)
        layMain?.tg_height.equal(.wrap).min(sv!.tg_height, increment: 0)
        sv?.addSubview(layMain!)
        uiCommon()
        uiMagic()
        uiTrap()
        uiMonster()
        btnTypeMonClicked(sender: nil)
    }
    
    private func uiCommon() {
        let layCommon = TGLinearLayout(.horz)
        layCommon.tg_width.equal(100%)
        layCommon.tg_height.equal(32)
        layMain?.addSubview(layCommon)
        let txt = UILabel()
        txt.tg_size(width: 25%, height: .fill)
        txt.text = "卡片种类"
        layCommon.addSubview(txt)
        let layBtn = TGLinearLayout(.horz)
        layBtn.tg_size(width: 75%, height: .fill)
        layCommon.addSubview(layBtn)
        
        func makeButton(title: String) -> UIButton {
            let btn = UIButton(type: UIButton.ButtonType.system)
            btn.tg_size(width: 60, height: .fill)
            btn.setTitle(title, for: UIControl.State.normal)
            btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            layBtn.addSubview(btn)
            return btn
        }
        
        btnTypeMon = makeButton(title: "怪兽")
        btnTypeMagic = makeButton(title: "魔法")
        btnTypeTrap = makeButton(title: "陷阱")
        let layEffect = TGLinearLayout(.horz)
        layEffect.tg_size(width: 100%, height: 32)
        layMain?.addSubview(layEffect)
        let txtEff = UILabel()
        txtEff.tg_size(width: 25%, height: .fill)
        txtEff.text = "卡片效果"
        layEffect.addSubview(txtEff)
        edtEffect = UITextField()
        edtEffect?.borderStyle = UITextField.BorderStyle.none
        edtEffect?.tg_size(width: 75%, height: 32)
        edtEffect?.placeholder = "输入效果关键字"
        edtEffect?.returnKeyType = UIReturnKeyType.done
        edtEffect?.delegate = self
        layEffect.addSubview(edtEffect!)
        
        let v = UIView()
        v.tg_size(width: 100%, height: 1)
        v.backgroundColor = UIColor.lightGray
        layMain?.addSubview(v)
        
        func makeLayout(v: TGVisibility) -> TGLinearLayout {
            let lay = TGLinearLayout(.vert)
            lay.tg_size(width: 100%, height: .wrap)
            lay.tg_visibility = v
            layMain?.addSubview(lay)
            return lay
        }
        
        layMonster = makeLayout(v: TGVisibility.visible)
        layMagic = makeLayout(v: TGVisibility.gone)
        layTrap = makeLayout(v: TGVisibility.gone)
        
        btnTypeMon?.addTarget(self, action: #selector(btnTypeMonClicked(sender:)), for: UIControl.Event.touchDown)
        btnTypeMagic?.addTarget(self, action: #selector(btnTypeMagicClicked(sender:)), for: UIControl.Event.touchDown)
        btnTypeTrap?.addTarget(self, action: #selector(btnTypeTrapClicked(sender:)), for: UIControl.Event.touchDown)
        
    }
    
    @objc func btnTypeMonClicked(sender: Any?) {
        cardtype = "怪兽"
        btnTypeMon?.setTitleColor(self.view.tintColor, for: UIControl.State.normal)
        btnTypeMagic?.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnTypeTrap?.setTitleColor(UIColor.black, for: UIControl.State.normal)
        layMonster?.tg_visibility = TGVisibility.visible
        layMagic?.tg_visibility = TGVisibility.gone
        layTrap?.tg_visibility = TGVisibility.gone
    }
    
    @objc func btnTypeMagicClicked(sender: Any?) {
        cardtype = "魔法"
        btnTypeMagic?.setTitleColor(self.view.tintColor, for: UIControl.State.normal)
        btnTypeMon?.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnTypeTrap?.setTitleColor(UIColor.black, for: UIControl.State.normal)
        layMagic?.tg_visibility = TGVisibility.visible
        layMonster?.tg_visibility = TGVisibility.gone
        layTrap?.tg_visibility = TGVisibility.gone
    }
    
    @objc func btnTypeTrapClicked(sender: Any?) {
        cardtype = "陷阱"
        btnTypeTrap?.setTitleColor(self.view.tintColor, for: UIControl.State.normal)
        btnTypeMon?.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnTypeMagic?.setTitleColor(UIColor.black, for: UIControl.State.normal)
        layTrap?.tg_visibility = TGVisibility.visible
        layMonster?.tg_visibility = TGVisibility.gone
        layMagic?.tg_visibility = TGVisibility.gone
    }
    
    private func uiMagic() {
        let txt = UILabel()
        txt.tg_size(width: 100%, height: 32)
        txt.text = "陷阱种类"
        layTrap?.addSubview(txt)
        let lay = TGLinearLayout(.horz)
        lay.tg_size(width: 100%, height: 32)
        layTrap?.addSubview(lay)
        func makeButton(title: String) -> UIButton {
            let btn = UIButton(type: UIButton.ButtonType.system)
            btn.tg_size(width: TGWeight.init(1), height: 32)
            btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            btn.setTitle(title, for: UIControl.State.normal)
            btn.addTarget(self, action: #selector(btnItemClicked(sender:)), for: UIControl.Event.touchDown)
            lay.addSubview(btn)
            return btn
        }
        btnTtNormal = makeButton(title: "通常")
        btnTtCont = makeButton(title: "永续")
        btnTtCounter = makeButton(title: "反击")
    }
    
    private func uiTrap() {
        let txt = UILabel()
        txt.tg_size(width: 100%, height: 32)
        txt.text = "魔法种类"
        layMagic?.addSubview(txt)
        let lay = TGLinearLayout(.horz)
        lay.tg_size(width: 100%, height: 32)
        layMagic?.addSubview(lay)
        
        func makeButton(title: String) -> UIButton {
            let btn = UIButton(type: UIButton.ButtonType.system)
            btn.tg_size(width: TGWeight.init(1), height: 32)
            btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            btn.setTitle(title, for: UIControl.State.normal)
            btn.addTarget(self, action: #selector(btnItemClicked(sender:)), for: UIControl.Event.touchDown)
            lay.addSubview(btn)
            return btn
        }
        
        btnMtNormal = makeButton(title: "通常")
        btnMtEquip = makeButton(title: "装备")
        btnMtQuick = makeButton(title: "速攻")
        btnMtCont = makeButton(title: "永续")
        btnMtField =  makeButton(title: "场地")
        btnMtRitual =  makeButton(title: "仪式")
    }
    
    private func uiMonster() {
        // ui monster
        func makeText(txt: String) -> UILabel {
            let t = UILabel()
            t.tg_size(width: 100%, height: 32)
            t.text = txt
            return t
        }
        
        func makeButton(_ txt: String, _ layout: TGLinearLayout) -> UIButton {
            let btn = UIButton(type: UIButton.ButtonType.system)
            btn.tg_size(width: TGWeight.init(1), height: 32)
            btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            btn.setTitle(txt, for: UIControl.State.normal)
            btn.addTarget(self, action: #selector(btnItemClicked(sender:)), for: UIControl.Event.touchDown)
            layout.addSubview(btn)
            return btn
        }
        
        func makeEditor(_ txt: String, _ placeholder: String) -> UITextField {
            let lay = TGLinearLayout(.horz)
            lay.tg_size(width: 100%, height: 32)
            layMonster?.addSubview(lay)
            let t = UILabel()
            t.tg_size(width: 25%, height: 32)
            t.text = txt
            lay.addSubview(t)
            let edt = UITextField()
            edt.borderStyle = UITextField.BorderStyle.none
            edt.tg_size(width: 75%, height: 32)
            edt.placeholder = placeholder
            edt.returnKeyType = UIReturnKeyType.done
            edt.delegate = self
            lay.addSubview(edt)
            let v = UIView()
            v.tg_size(width: 100%, height: 1)
            v.backgroundColor = UIColor.lightGray
            layMonster?.addSubview(v)
            return edt
        }
        
        layMonster?.addSubview(makeText(txt: "怪兽属性"))
        let layElement = TGLinearLayout(.horz)
        layElement.tg_size(width: 100%, height: 32)
        layMonster?.addSubview(layElement)
        btnMonEleLight = makeButton("光", layElement)
        btnMonEleDark = makeButton("暗", layElement)
        btnMonEleFire = makeButton("炎", layElement)
        btnMonEleWater = makeButton("水", layElement)
        btnMonEleEarth = makeButton("地", layElement)
        btnMonEleWind = makeButton("风", layElement)
        btnMonEleGod = makeButton("神", layElement)
        layMonster?.addSubview(makeText(txt: "怪兽种类"))
        let layMonType1 = TGLinearLayout(.horz)
        layMonType1.tg_size(width: 100%, height: 32)
        layMonster?.addSubview(layMonType1)
        btnMonTypeNormal = makeButton("通常", layMonType1)
        btnMonTypeEffect = makeButton("效果", layMonType1)
        btnMonTypeRitual = makeButton("仪式", layMonType1)
        btnMonTypeFusion = makeButton("融合", layMonType1)
        btnMonTypeSync = makeButton("同调", layMonType1)
        btnMonTypeXyz = makeButton("XYZ", layMonType1)
        btnMonTypeToon = makeButton("卡通", layMonType1)
        let layMonType2 = TGLinearLayout(.horz)
        layMonType2.tg_size(width: 100%, height: 32)
        layMonster?.addSubview(layMonType2)
        btnMonTypeUnion = makeButton("同盟", layMonType2)
        btnMonTypeSpirit = makeButton("灵魂", layMonType2)
        btnMonTypeTuner = makeButton("调整", layMonType2)
        btnMonTypeDouble = makeButton("二重", layMonType2)
        btnMonTypePendulum = makeButton("灵摆", layMonType2)
        btnMonTypeReverse = makeButton("反转", layMonType2)
        btnMonTypeSS = makeButton("特殊召唤", layMonType2)
        btnMonTypeSS?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        let layMonType3 = TGLinearLayout(.horz)
        layMonType3.tg_size(width: 100%, height: 32)
        layMonster?.addSubview(layMonType3)
        btnMonTypeLink = makeButton("连接", layMonType3)
        // fill blank
        _ = makeButton("", layMonType3)
        _ = makeButton("", layMonType3)
        _ = makeButton("", layMonType3)
        _ = makeButton("", layMonType3)
        _ = makeButton("", layMonType3)
        _ = makeButton("", layMonType3)
        
        // race
        layMonster?.addSubview(makeText(txt: "怪兽种族"))
        let layMonRace1 = TGLinearLayout(.horz)
        layMonRace1.tg_size(width: 100%, height: 32)
        layMonster?.addSubview(layMonRace1)
        btnMonRaceWater = makeButton("水", layMonRace1)
        btnMonRaceBeast = makeButton("兽", layMonRace1)
        btnMonRaceBW = makeButton("兽战士", layMonRace1)
        btnMonRaceCreation = makeButton("创造神", layMonRace1)
        btnMonRaceDino = makeButton("恐龙", layMonRace1)
        btnMonRaceGod = makeButton("幻神兽", layMonRace1)
        btnMonRaceDragon = makeButton("龙", layMonRace1)
        let layMonRace2 = TGLinearLayout(.horz)
        layMonRace2.tg_size(width: 100%, height: 32)
        layMonster?.addSubview(layMonRace2)
        btnMonRaceAngel = makeButton("天使", layMonRace2)
        btnMonRaceDemon = makeButton("恶魔", layMonRace2)
        btnMonRaceFish = makeButton("鱼", layMonRace2)
        btnMonRaceInsect = makeButton("昆虫", layMonRace2)
        btnMonRaceMachine = makeButton("机械", layMonRace2)
        btnMonRacePlant = makeButton("植物", layMonRace2)
        btnMonRaceCy = makeButton("念动力", layMonRace2)
        let layMonRace3 = TGLinearLayout(.horz)
        layMonRace3.tg_size(width: 100%, height: 32)
        layMonster?.addSubview(layMonRace3)
        btnMonRaceFire = makeButton("炎", layMonRace3)
        btnMonRaceClaim = makeButton("爬虫类", layMonRace3)
        btnMonRaceRock = makeButton("岩石", layMonRace3)
        btnMonRaceSD = makeButton("海龙", layMonRace3)
        btnMonRaceMagician = makeButton("魔法师", layMonRace3)
        btnMonRaceThunder = makeButton("雷", layMonRace3)
        btnMonRaceWarrior = makeButton("战士", layMonRace3)
        let layMonRace4 = TGLinearLayout(.horz)
        layMonRace4.tg_size(width: 100%, height: 32)
        layMonster?.addSubview(layMonRace4)
        btnMonRaceWB = makeButton("鸟兽", layMonRace4)
        btnMonRaceUndead = makeButton("不死", layMonRace4)
        btnMonRaceDD = makeButton("幻龙", layMonRace4)
        btnMonRaceCyber = makeButton("电子界", layMonRace4)
        _ = makeButton("", layMonRace4)
        _ = makeButton("", layMonRace4)
        _ = makeButton("", layMonRace4)
        // level
        edtLevel = makeEditor("星数阶级", "可以是范围，如 1-4")
        edtScale = makeEditor("灵摆刻度", "可以是范围，如 1-4")
        edtAtk = makeEditor("攻击力", "可以是范围，如 1500-2000")
        edtDef = makeEditor("守备力", "可以是范围，如 1500-2000")
        edtLink = makeEditor("连接值", "可以是范围，如 1-3")
        layMonster?.addSubview(makeText(txt: "连接方向"))
        
        func makeLinkArrow(_ txt: String, _ layout: TGLinearLayout) -> UIButton {
            let btn = UIButton(type: UIButton.ButtonType.system)
            btn.tg_size(width: 40, height: 40)
            btn.setTitle(txt, for: UIControl.State.normal)
            btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            btn.addTarget(self, action: #selector(btnItemClicked(sender:)), for: UIControl.Event.touchDown)
            layout.addSubview(btn)
            return btn
        }
        
        let layArrow = TGLinearLayout(.vert)
        layArrow.tg_size(width: .wrap, height: 120)
        layArrow.tg_centerX.equal(0)
        layMonster?.addSubview(layArrow)
        let layArrowSub1 = TGLinearLayout(.horz)
        layArrowSub1.tg_size(width: .wrap, height: 32)
        layArrow.addSubview(layArrowSub1)
        let layArrowSub2 = TGLinearLayout(.horz)
        layArrowSub2.tg_size(width: .wrap, height: 32)
        layArrow.addSubview(layArrowSub2)
        let layArrowSub3 = TGLinearLayout(.horz)
        layArrowSub3.tg_size(width: .wrap, height: 32)
        layArrow.addSubview(layArrowSub3)
        btnLink7 = makeLinkArrow("↖", layArrowSub1)
        btnLink8 = makeLinkArrow("↑", layArrowSub1)
        btnLink9 = makeLinkArrow("↗", layArrowSub1)
        btnLink4 = makeLinkArrow("←", layArrowSub2)
        btnLink5 = makeLinkArrow("", layArrowSub2)
        btnLink6 = makeLinkArrow("→", layArrowSub2)
        btnLink1 = makeLinkArrow("↙", layArrowSub3)
        btnLink2 = makeLinkArrow("↓", layArrowSub3)
        btnLink3 = makeLinkArrow("↘", layArrowSub3)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSearchClicked(sender: Any?) {
        doSearch()
    }
    
    private func isButtonSelected(_ btn: UIButton?) -> Bool {
        let color = btn?.titleColor(for: UIControl.State.normal)
        return color != UIColor.black
    }
    
    private func buildMonsterCardType() -> String {
        var key = ""
        if (isButtonSelected(btnMonTypeNormal)) { key += "通常," }
        if (isButtonSelected(btnMonTypeEffect)) { key += "效果," }
        if (isButtonSelected(btnMonTypeRitual)) { key += "仪式," }
        if (isButtonSelected(btnMonTypeFusion)) { key += "融合," }
        if (isButtonSelected(btnMonTypeSync)) { key += "同调," }
        if (isButtonSelected(btnMonTypeXyz)) { key += "XYZ," }
        if (isButtonSelected(btnMonTypeToon)) { key += "卡通," }
        if (isButtonSelected(btnMonTypeUnion)) { key += "同盟," }
        if (isButtonSelected(btnMonTypeSpirit)) { key += "灵魂," }
        if (isButtonSelected(btnMonTypeTuner)) { key += "调整," }
        if (isButtonSelected(btnMonTypeDouble)) { key += "二重," }
        if (isButtonSelected(btnMonTypePendulum)) { key += "灵摆," }
        if (isButtonSelected(btnMonTypeReverse)) { key += "反转," }
        if (isButtonSelected(btnMonTypeSS)) { key += "特殊召唤," }
        if (isButtonSelected(btnMonTypeLink)) { key += "连接," }
        key = key.trim(c: [","])
        return key
    }
    
    private func buildMonsterRace() -> String {
        var key = ""
        if (isButtonSelected(btnMonRaceWater)) { key += "水," }
        if (isButtonSelected(btnMonRaceBeast)) { key += "兽," }
        if (isButtonSelected(btnMonRaceBW)) { key += "兽战士," }
        if (isButtonSelected(btnMonRaceCreation)) { key += "创造神," }
        if (isButtonSelected(btnMonRaceDino)) { key += "恐龙," }
        if (isButtonSelected(btnMonRaceGod)) { key += "幻神兽," }
        if (isButtonSelected(btnMonRaceDragon)) { key += "龙," }
        
        if (isButtonSelected(btnMonRaceAngel)) { key += "天使," }
        if (isButtonSelected(btnMonRaceDemon)) { key += "恶魔," }
        if (isButtonSelected(btnMonRaceFish)) { key += "鱼," }
        if (isButtonSelected(btnMonRaceInsect)) { key += "昆虫," }
        if (isButtonSelected(btnMonRaceMachine)) { key += "机械," }
        if (isButtonSelected(btnMonRacePlant)) { key += "植物," }
        if (isButtonSelected(btnMonRaceCy)) { key += "念动力," }
        
        if (isButtonSelected(btnMonRaceFire)) { key += "炎," }
        if (isButtonSelected(btnMonRaceClaim)) { key += "爬虫类," }
        if (isButtonSelected(btnMonRaceRock)) { key += "岩石," }
        if (isButtonSelected(btnMonRaceSD)) { key += "海龙," }
        if (isButtonSelected(btnMonRaceMagician)) { key += "魔法师," }
        if (isButtonSelected(btnMonRaceThunder)) { key += "雷," }
        if (isButtonSelected(btnMonRaceWarrior)) { key += "战士," }
        
        if (isButtonSelected(btnMonRaceWB)) { key += "鸟兽," }
        if (isButtonSelected(btnMonRaceUndead)) { key += "不死," }
        if (isButtonSelected(btnMonRaceDD)) { key += "幻龙," }
        if (isButtonSelected(btnMonRaceCyber)) { key += "电子界," }
        key = key.trim(c: [","])
        return key
    }
    
    private func buildMonsterElement() -> String {
        var key = ""
        if (isButtonSelected(btnMonEleLight)) { key += "光," }
        if (isButtonSelected(btnMonEleDark)) { key += "暗," }
        if (isButtonSelected(btnMonEleFire)) { key += "炎," }
        if (isButtonSelected(btnMonEleWater)) { key += "水," }
        if (isButtonSelected(btnMonEleEarth)) { key += "地," }
        if (isButtonSelected(btnMonEleWind)) { key += "风," }
        if (isButtonSelected(btnMonEleGod)) { key += "神," }
        key = key.trim(c: [","])
        return key
    }
    
    private func buildMonsterLinkArrow() -> String {
        var key = ""
        if (isButtonSelected(btnLink1)) { key += "1," }
        if (isButtonSelected(btnLink2)) { key += "2," }
        if (isButtonSelected(btnLink3)) { key += "3," }
        if (isButtonSelected(btnLink4)) { key += "4," }
        if (isButtonSelected(btnLink6)) { key += "6," }
        if (isButtonSelected(btnLink7)) { key += "7," }
        if (isButtonSelected(btnLink8)) { key += "8," }
        if (isButtonSelected(btnLink9)) { key += "9," }
        key = key.trim(c: [","])
        return key
    }
    
    private func buildMagicCardType() -> String {
        var key = ""
        if (isButtonSelected(btnMtNormal)) { key += "通常," }
        if (isButtonSelected(btnMtEquip)) { key += "装备," }
        if (isButtonSelected(btnMtQuick)) { key += "速攻," }
        if (isButtonSelected(btnMtCont)) { key += "永续," }
        if (isButtonSelected(btnMtField)) { key += "场地," }
        if (isButtonSelected(btnMtRitual)) { key += "仪式," }
        key = key.trim(c: [","])
        return key
    }
    
    private func buildTrapCardType() -> String {
        var key = ""
        if (isButtonSelected(btnTtNormal)) { key += "通常," }
        if (isButtonSelected(btnTtCont)) { key += "永续," }
        if (isButtonSelected(btnTtCounter)) { key += "反击," }
        key = key.trim(c: [","])
        return key
    }

    private func doSearch() {
        // do search
        var key = " +(类:\(cardtype))"
        let eff = edtEffect!.text!
        if (eff != "") {
            key += " +(效果:\(eff))"
        }
        if (cardtype == "怪兽") {
            let atk = edtAtk!.text!
            if (atk != "") {
                key += " +(atk:\(atk))"
            }
            let def = edtDef!.text!
            if (def != "") {
                key += " +(atk:\(def))"
            }
            let lvl = edtLevel!.text!
            if (lvl != "") {
                key += " +(level:\(lvl))"
            }
            let scale = edtScale!.text!
            if (scale != "") {
                key += " +(刻度:\(scale))"
            }
            let link = edtLink!.text!
            if (link != "") {
                key += " +(link:\(link))"
            }
            let ct2 = buildMonsterCardType()
            if (ct2 != "") {
                key += " +(类:\(ct2))"
            }
            let race = buildMonsterRace()
            if (race != "") {
                key += " +(族:\(race))"
            }
            let ele = buildMonsterElement()
            if (ele != "") {
                key += " +(属性:\(ele))"
            }
            let la = buildMonsterLinkArrow()
            if (la != "") {
                key += " +(linkArrow:\(la))"
            }
        } else if (cardtype == "魔法") {
            let ct2 = buildMagicCardType()
            if (ct2 != "") {
                key += " +(类:\(ct2))"
            }
        } else if (cardtype == "陷阱") {
            let ct2 = buildTrapCardType()
            if (ct2 != "") {
                key += " +(类:\(ct2))"
            }
        }
        let c = vc(name: "cardlist") as! CardListController
        c.key = key
        navigationController?.pushViewController(c, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField != edtEffect) {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 271.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField != edtEffect) {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 271.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
        return true
    }
    
    @objc func btnItemClicked(sender: UIButton) {
        let c = sender.titleColor(for: UIControl.State.normal)
        if (c == UIColor.black) {
            sender.setTitleColor(self.view.tintColor, for: UIControl.State.normal)
        } else {
            sender.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
    }
    
}
