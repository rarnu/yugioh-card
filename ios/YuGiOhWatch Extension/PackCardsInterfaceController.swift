//
//  PackCardsInterfaceController.swift
//  YuGiOhWatch Extension
//
//  Created by rarnu on 2019/2/8.
//  Copyright © 2019 rarnu. All rights reserved.
//

import WatchKit
import Foundation
import YGOAPI2Watch

class PackCardRowController: NSObject {
    @IBOutlet var lblName: WKInterfaceLabel!
}

class PackCardsInterfaceController: WKInterfaceController {

    @IBOutlet var tvPackCards: WKInterfaceTable!
    @IBOutlet var lblLoading: WKInterfaceLabel!
    
    var url = ""
    var list = Array<CardInfo2>()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.url = context as! String
        queryPackCardsData()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    private func queryPackCardsData() {
        YGOData2.packageDetail(self.url) { r in
            self.list.removeAll()
            for ci in r.data {
                self.list.append(ci)
            }
            self.lblLoading.setHidden(true)
            self.buildPackCardsTable()
        }
    }
    
    private func buildPackCardsTable() {
        tvPackCards.setNumberOfRows(list.count, withRowType: "Cell")
        for i in list.indices {
            let r = tvPackCards.rowController(at: i) as! PackCardRowController
            r.lblName.setText(list[i].name)
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: "CardDetailInterfaceController", context: list[rowIndex].hashid)
    }

}
