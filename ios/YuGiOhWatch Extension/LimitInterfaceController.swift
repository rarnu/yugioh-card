//
//  LimitInterfaceController.swift
//  YuGiOhWatch Extension
//
//  Created by rarnu on 2019/2/7.
//  Copyright © 2019 rarnu. All rights reserved.
//

import WatchKit
import Foundation
import YGOAPI2Watch

class CardRowController: NSObject {
    @IBOutlet var lblName: WKInterfaceLabel!
    @IBOutlet var lblType: WKInterfaceLabel!
}

class LimitInterfaceController: WKInterfaceController {

    @IBOutlet var tvLimit: WKInterfaceTable!
    @IBOutlet var lblLoading: WKInterfaceLabel!
    private var list = Array<LimitInfo2>()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        queryLimitData()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: "CardDetailInterfaceController", context: list[rowIndex].hashid)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func queryLimitData() {
        YGOData2.limit() { l in
            self.list = l
            self.lblLoading.setHidden(true)
            self.buildLimitTable()
        }
    }

    private func buildLimitTable() {
        tvLimit.setNumberOfRows(list.count, withRowType: "Cell")
        for i in list.indices {
            let r = tvLimit.rowController(at: i) as! CardRowController
            r.lblName.setText(list[i].name)
            switch list[i].limit {
            case 0:
                r.lblName.setTextColor(UIColor.red)
                break
            case 1:
                r.lblName.setTextColor(UIColor.orange)
                break
            default:
                r.lblName.setTextColor(UIColor.green)
                break
            }
            r.lblType.setTextColor(UIColor.parseString(list[i].color))
        }
    }
    
}
