//
//  DeckController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2019/8/15.
//  Copyright © 2019 rarnu. All rights reserved.
//

import UIKit
import commonios
import TangramKit
import YGOAPI2

class DeckController: UIViewController {

    var deckcode = ""
    private var layMain: TGLinearLayout!
    private var layDeck: TGLinearLayout!
    
    func makeLayout() -> TGLinearLayout {
        let lay = TGLinearLayout(.vert)
        lay.tg_vspace = 0
        lay.tg_width.equal(100%)
        lay.tg_height.equal(.wrap)
        layMain.addSubview(lay)
        return lay
    }
    
    func makeDeckView(_ detail: DeckDetail) {
        let lblDeckName = UILabel()
        lblDeckName.tg_width.equal(100%)
        lblDeckName.tg_height.equal(.wrap)
        lblDeckName.tg_vertMargin(4.0)
        lblDeckName.text = detail.name
        lblDeckName.font = UIFont.systemFont(ofSize: 18)
        lblDeckName.textColor = UIColor.white
        self.layDeck.addSubview(lblDeckName)
        
        let layCards = TGLinearLayout(.horz)
        layCards.tg_width.equal(100%)
        layCards.tg_height.equal(.wrap)
        self.layDeck.addSubview(layCards)
        
        let layMonster = TGLinearLayout(.vert)
        layMonster.tg_width.equal(33%)
        layMonster.tg_height.equal(.wrap)
        layCards.addSubview(layMonster)
        
        let layMagicTrap = TGLinearLayout(.vert)
        layMagicTrap.tg_width.equal(33%)
        layMagicTrap.tg_height.equal(.wrap)
        layCards.addSubview(layMagicTrap)
        
        let layExtra = TGLinearLayout(.vert)
        layExtra.tg_width.equal(33%)
        layExtra.tg_height.equal(.wrap)
        layCards.addSubview(layExtra)
        
        let lblMonster = UILabel()
        lblMonster.tg_width.equal(100%)
        lblMonster.tg_height.equal(.wrap)
        lblMonster.textColor = UIColor.white
        lblMonster.backgroundColor = UIColor.black
        lblMonster.font = UIFont.systemFont(ofSize: 11)
        lblMonster.text = detail.monster.map { c in "\(c.count) \(c.name)" }.joinToString(sep: "\n")
        layMonster.addSubview(lblMonster)
        
        let lblMagicTrap = UILabel()
        lblMagicTrap.tg_width.equal(100%)
        lblMagicTrap.tg_height.equal(.wrap)
        lblMagicTrap.textColor = UIColor.white
        lblMagicTrap.backgroundColor = UIColor.black
        lblMagicTrap.font = UIFont.systemFont(ofSize: 11)
        lblMagicTrap.text = detail.magictrap.map { c in "\(c.count) \(c.name)" }.joinToString(sep: "\n")
        layMagicTrap.addSubview(lblMagicTrap)
        
        let lblExtra = UILabel()
        lblExtra.tg_width.equal(100%)
        lblExtra.tg_height.equal(.wrap)
        lblExtra.textColor = UIColor.white
        lblExtra.backgroundColor = UIColor.black
        lblExtra.font = UIFont.systemFont(ofSize: 11)
        lblExtra.text = detail.extra.map { c in "\(c.count) \(c.name)" }.joinToString(sep: "\n")
        layExtra.addSubview(lblExtra)
        
        let imgDeck = UIImageView()
        imgDeck.tg_width.equal(100%)
        imgDeck.tg_height.equal(.wrap)
        let layImg = TGRelativeLayout()
        layImg.tg_width.equal(100%)
        layImg.tg_height.equal(.wrap)
        layImg.tg_vertMargin(8.0)
        layImg.tg_centerX.equal(0)
        layImg.tg_centerY.equal(0)
        layImg.addSubview(imgDeck)
        self.layDeck.addSubview(layImg)
        
        let vSpl = UIView()
        vSpl.tg_width.equal(100%)
        vSpl.tg_height.equal(1)
        vSpl.tg_vertMargin(8.0)
        vSpl.backgroundColor = UIColor.darkGray
        self.layDeck.addSubview(vSpl)
        
        let enc = detail.image.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        if (enc != nil) {
            let localImg = File(enc!.sub(afterLast: "/"))
            if (localImg.exists()) {
                imgDeck.image = UIImage(contentsOfFile: localImg.absolutePath)
            } else {
                let reqUrl = "https://www.ygo-sem.cn/\(enc!)"
                download(reqUrl, localImg.absolutePath) { (state, _, _, _) in
                    if (state == DownloadState.Complete) {
                        if (localImg.exists()) {
                            mainThread {
                                imgDeck.image = UIImage(contentsOfFile: localImg.absolutePath)
                                imgDeck.tg_width.equal(100%)
                                imgDeck.tg_height.equal(.wrap)
                            }
                        }
                    }
                }
            }
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
        
        YGOData2.deckDetail(deckcode) { list in
            mainThread {
                for detail in list {
                    self.makeDeckView(detail)
                }
            }
        }
    }
    
}
