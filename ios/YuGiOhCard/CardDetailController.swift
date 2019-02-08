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
import TangramKit
import YGOAPI2

class CardDetailController: UIViewController {

    var cardname = ""
    var hashid = ""
    
    var wikiForPass = ""
    
    // ui
    var sv: UIScrollView?
    var layMain: TGLinearLayout?
    
    var tvCardNameValue: UILabel?
    var tvCardJapNameValue: UILabel?
    var tvCardEnNameValue: UILabel?
    var tvCardTypeValue: UILabel?
    var tvPasswordValue: UILabel?
    var tvLimitValue: UILabel?
    var tvRareValue: UILabel?
    var tvPackValue: UILabel?
    var tvEffectValue: UILabel?
    // monster
    var tvMonRace: UILabel?
    var tvMonElement: UILabel?
    var tvMonLevel: UILabel?
    var tvMonAtk: UILabel?
    var tvMonDef: UILabel?
    var tvMonLink: UILabel?
    var tvMonLinkArrow: UILabel?
    
    // image
    var ivCardImg: UIImageView?
    // adjust
    var tvAdjust: UILabel?
    
    private func makeAdjust() -> UILabel {
        let lbl = UILabel()
        lbl.tg_width.equal(100%)
        lbl.tg_height.equal(.wrap)
        lbl.font = UIFont.systemFont(ofSize: 15)
        layMain?.addSubview(lbl)
        return lbl
    }
    
    private func makeLabel(_ txt: String, _ multiLine: Bool = false, _ h: CGFloat = 24) -> UILabel {
        let laySub = TGLinearLayout(.horz)
        laySub.tg_width.equal(100%)
        laySub.tg_height.equal(.wrap)
        layMain?.addSubview(laySub)
        let lbl = UILabel()
        lbl.tg_width.equal(25%)
        lbl.tg_height.equal(24)
        lbl.text = txt
        laySub.addSubview(lbl)
        let lblValue = UILabel()
        if (h > 24) {
            lblValue.tg_width.equal(100%)
            lblValue.tg_height.equal(.wrap)
            let lblSub = TGLinearLayout(.vert)
            lblSub.tg_width.equal(75%)
            lblSub.tg_height.equal(.wrap)
            let lblFill = UILabel()
            lblFill.tg_width.equal(100%)
            lblFill.tg_height.equal(4)
            lblSub.addSubview(lblFill)
            lblSub.addSubview(lblValue)
            laySub.addSubview(lblSub)
        } else {
            lblValue.tg_width.equal(75%)
            lblValue.tg_height.equal(h)
            laySub.addSubview(lblValue)
        }
        if (multiLine) {
            lblValue.lineBreakMode = NSLineBreakMode.byWordWrapping
            lblValue.numberOfLines = 0
        } else {
            lblValue.numberOfLines = 1
        }
        return lblValue
    }
    
    private func makeLine() -> UIView {
        let v = UIView()
        v.tg_width.equal(100%)
        v.tg_height.equal(1)
        v.tg_vertMargin(16)
        v.backgroundColor = UIColor.lightGray
        layMain?.addSubview(v)
        return v
    }
    
    private func makeImage() -> UIImageView {
        let img = UIImageView()
        img.tg_width.equal(160)
        img.tg_height.equal(230)
        let lay = TGRelativeLayout()
        lay.tg_width.equal(100%)
        lay.tg_height.equal(230)
        img.tg_centerX.equal(0)
        img.tg_centerY.equal(0)
        lay.addSubview(img)
        layMain?.addSubview(lay)
        return img
    }
    
    private func getTextSize(str: String, width: Int, fontSize: CGFloat) -> CGSize {
        let strSize = (str as NSString).boundingRect(with: CGSize(width: width, height: 0), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size
        return strSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = cardname
        sv = UIScrollView(frame: CGRect(x: 8, y: 8, width: screenWidth() - 16, height: screenHeight() - 16))
        sv?.showsVerticalScrollIndicator = false
        sv?.showsHorizontalScrollIndicator = false
        self.view.addSubview(sv!)
        layMain = TGLinearLayout(.vert)
        layMain?.tg_vspace = 0
        layMain?.tg_width.equal(100%)
        layMain?.tg_height.equal(.wrap).min(sv!.tg_height, increment: 0)
        sv?.addSubview(layMain!)
        tvCardNameValue = makeLabel("中文名称:")
        tvCardJapNameValue = makeLabel("日文名称:")
        tvCardEnNameValue = makeLabel("英文名称:")
        tvCardTypeValue = makeLabel("卡片种类:")
        tvPasswordValue = makeLabel("卡片密码:")
        tvLimitValue = makeLabel("使用限制:")
        tvRareValue = makeLabel("罕贵度:")
        tvPackValue = makeLabel("所在卡包:")
        
        YGOData2.cardDetail(self.hashid) { c in
            self.mainThread {
                self.tvCardNameValue?.text = c.name
                self.tvCardJapNameValue?.text = c.japname
                self.tvCardEnNameValue?.text = c.enname
                self.tvCardTypeValue?.text = c.cardtype
                self.tvPasswordValue?.text = c.password
                self.tvLimitValue?.text = c.limit
                self.tvRareValue?.text = c.rare
                self.tvPackValue?.text = c.pack
                
                if (c.cardtype.contains("怪兽")) {
                    self.tvMonRace = self.makeLabel("怪兽种族:")
                    self.tvMonRace?.text = c.race
                    self.tvMonElement = self.makeLabel("怪兽属性:")
                    self.tvMonElement?.text = c.element
                    
                    if (c.cardtype.contains("连接")) {
                        // link monster
                        self.tvMonAtk = self.makeLabel("攻击力:")
                        self.tvMonAtk?.text = c.atk
                        self.tvMonLink = self.makeLabel("连接数:")
                        self.tvMonLink?.text = c.link
                        self.tvMonLinkArrow = self.makeLabel("连接方向:")
                        self.tvMonLinkArrow?.text = c.linkarrow
                        
                    } else {
                        if (c.cardtype.contains("XYZ")) {
                            self.tvMonLevel = self.makeLabel("怪兽阶级:")
                        } else {
                            self.tvMonLevel = self.makeLabel("怪兽星级:")
                        }
                        self.tvMonLevel?.text = c.level
                        self.tvMonAtk = self.makeLabel("攻击力:")
                        self.tvMonAtk?.text = c.atk
                        self.tvMonDef = self.makeLabel("守备力:")
                        self.tvMonDef?.text = c.def
                    }
                }
                
                let size = self.getTextSize(str: c.effect, width:Int(screenWidth() - 16 - 80 - 8), fontSize: 17)
                self.tvEffectValue = self.makeLabel("效果:", true, size.height)
                self.tvEffectValue?.text = c.effect
                _ = self.makeLine()
                self.ivCardImg = self.makeImage()
                self.loadImage(cardid: c.imageId)
                _ = self.makeLine()
                self.tvAdjust = self.makeAdjust()
                self.tvAdjust?.text = c.adjust
                self.wikiForPass = c.wiki
            }
        }
    }
    
    private func loadImage(cardid: Int) {
        let localfile = documentPath(true) + "\(cardid)"
        if (FileManager.default.fileExists(atPath: localfile)) {
            self.ivCardImg?.image = UIImage(contentsOfFile: localfile)
        } else {
            download(String(format: RES_URL, cardid), localfile) { (state, _, _, _) in
                if (state == DownloadState.Complete) {
                    if (FileManager.default.fileExists(atPath: localfile)) {
                        self.mainThread {
                            self.ivCardImg?.image = UIImage(contentsOfFile: localfile)
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnWikiClicked(sender: Any?) {
        let c = vc(name: "wiki") as! CardWikiController
        c.wiki = wikiForPass
        navigationController?.pushViewController(c, animated: true)
    }
}
