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
        
        // TODO: get data
        print("code => \(deckcode)")
    }
    


}
