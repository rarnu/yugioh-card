//
//  CardDetailController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/5.
//  Copyright © 2018 rarnu. All rights reserved.
//

import Foundation
import UIKit
import sfunctional
import YGOAPI

class CardDetailController: UIViewController {

    var cardid = 0
    var cardname = ""
    var hashid = ""
    
    // ui
    var sv: UIScrollView?
    var tvCardNameValue: UILabel?
    var tvCardJapNameValue: UILabel?
    var tvCardEnNameValue: UILabel?
    var tvCardTypeValue: UILabel?
    var tvPasswordValue: UILabel?
    var tvLimitValue: UILabel?
    var tvRareValue: UILabel?
    var tvPackValue: UILabel?
    var tvEffectValue: UILabel?
    
    private func makeLabel(_ x: Int, _ y: Int, _ width: Int, _ height: Int, _ txt: String, _ container: UIScrollView) -> UILabel {
        let lbl = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        lbl.numberOfLines = 1
        lbl.text = txt
        container.addSubview(lbl)
        return lbl
    }
    
    private func makeLine(_ x: Int, _ y: Int, _ width: Int, _ height: Int, _ container: UIScrollView) -> UIView {
        let v = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        v.backgroundColor = UIColor.lightGray
        container.addSubview(v)
        return v
    }
    
    private func getTextSize(str: String, width: Int, fontSize: CGFloat) -> CGSize {
        let strSize = (str as NSString).boundingRect(with: CGSize(width: width, height: 0), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size
        return strSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = cardname
        sv = UIScrollView(frame: CGRect(x: 8, y: 8, width: screenWidth() - 16, height: screenHeight() - 16))
        sv?.showsVerticalScrollIndicator = false
        sv?.showsHorizontalScrollIndicator = false
        
        let valueWidth = Int(screenWidth() - 16 - 80)
        _ = makeLabel(0, 0, 80, 32, "中文名称:", sv!)
        tvCardNameValue = makeLabel(88, 0, valueWidth, 32, "", sv!)
        _ = makeLabel(0, 32, 80, 32, "日文名称:", sv!)
        tvCardJapNameValue = makeLabel(88, 32, valueWidth, 32, "", sv!)
        _ = makeLabel(0, 64, 80, 32, "英文名称:", sv!)
        tvCardEnNameValue = makeLabel(88, 64, valueWidth, 32, "", sv!)
        _ = makeLabel(0, 96, 80, 32, "卡片种类:", sv!)
        tvCardTypeValue = makeLabel(88, 96, valueWidth, 32, "", sv!)
        _ = makeLabel(0, 128, 80, 32, "卡片密码:", sv!)
        tvPasswordValue = makeLabel(88, 128, valueWidth, 32, "", sv!)
        _ = makeLabel(0, 160, 80, 32, "使用限制:", sv!)
        tvLimitValue = makeLabel(88, 160, valueWidth, 32, "", sv!)
        _ = makeLabel(0, 192, 80, 32, "罕贵度:", sv!)
        tvRareValue = makeLabel(88, 192, valueWidth, 32, "", sv!)
        _ = makeLabel(0, 224, 80, 32, "所在卡包:", sv!)
        tvPackValue = makeLabel(88, 224, valueWidth, 32, "", sv!)
        _ = makeLabel(0, 256, 80, 32, "效果:", sv!)
        tvEffectValue = makeLabel(88, 262, valueWidth, 32, "", sv!)
        tvEffectValue?.lineBreakMode = NSLineBreakMode.byWordWrapping
        tvEffectValue?.numberOfLines = 0
        self.view.addSubview(sv!)
        
        thread {
            let ret = YGOData.cardDetail(self.hashid)
            if (ret != nil) {
                self.mainThread {
                    self.tvCardNameValue?.text = ret!.name
                    self.tvCardJapNameValue?.text = ret!.japname
                    self.tvCardEnNameValue?.text = ret!.enname
                    self.tvCardTypeValue?.text = ret!.cardtype
                    self.tvPasswordValue?.text = ret!.password
                    self.tvLimitValue?.text = ret!.limit
                    self.tvRareValue?.text = ret!.rare
                    self.tvPackValue?.text = ret!.pack
                    self.tvEffectValue?.text = ret!.effect
                    let size = self.getTextSize(str: ret!.effect, width:Int(screenWidth() - 16 - 80 - 8), fontSize: self.tvEffectValue!.font.pointSize)
                    self.tvEffectValue?.frame = CGRect(x: 88, y: 262, width: size.width, height: size.height)
                    
                    var top = 262 + size.height + 8
                    let subWidth = Int(screenWidth() - 16)
                    // line
                    _ = self.makeLine(0, Int(top), subWidth, 1, self.sv!)
                    _ = self.makeLabel(0, Int(top + 8), subWidth, 32, "发行卡包", self.sv!)
                    top += 40
                    if (ret!.packs != nil) {
                        for p in ret!.packs! {
                            let lbl = self.makeLabel(0, Int(top), subWidth, 20, "\(p.name!)", self.sv!)
                            lbl.font = UIFont.systemFont(ofSize: 12)
                            top += 20
                        }
                    }
                    
                    if (ret!.adjust != nil && ret!.adjust != "") {
                        _ = self.makeLine(0, Int(top + 8), subWidth, 1, self.sv!)
                        _ = self.makeLabel(0, Int(top + 16), subWidth, 32, "事务局调整", self.sv!)
                        top += 40
                        let lbl = self.makeLabel(0, Int(top), subWidth, 32, ret!.adjust, self.sv!)
                        lbl.font = UIFont.systemFont(ofSize: 14)
                        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
                        lbl.numberOfLines = 0
                        let adjSize = self.getTextSize(str: ret!.adjust, width: subWidth, fontSize: 14)
                        lbl.frame = CGRect(x: 0, y: CGFloat(top), width: adjSize.width, height: adjSize.height)
                        top += adjSize.height
                    }
                    
                    self.sv?.contentSize = CGSize(width: screenWidth() - 16, height:top + 8)
                    
                }
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnWikiClicked(sender: Any?) {
        let c = vc(name: "wiki") as! CardWikiController
        c.hashid = hashid
        navigationController?.pushViewController(c, animated: true)
    }
    
    @IBAction func btnImageClicked(sender: Any?) {
        let c = vc(name: "image") as! CardImageController
        c.cardid = cardid
        navigationController?.pushViewController(c, animated: true)
    }
}
