//
//  PackInterfaceController.swift
//  YuGiOhWatch Extension
//
//  Created by rarnu on 2019/2/7.
//  Copyright © 2019 rarnu. All rights reserved.
//

import WatchKit
import Foundation
import YGOAPI2Watch

class SeasonRowController: NSObject {
    @IBOutlet var lblName: WKInterfaceLabel!
}

class PackInterfaceController: WKInterfaceController {

    @IBOutlet var tvSeason: WKInterfaceTable!
    @IBOutlet var lblLoading: WKInterfaceLabel!
    
    var listSeason = Array<String>()
    var listPack = Array<PackageInfo2>()
    var listOrigin = Array<PackageInfo2>()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        queryPackData()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    private func queryPackData() {
        YGOData2.packageList() { l in
            self.listOrigin = l
            self.listSeason.removeAll()
            self.listPack.removeAll()
            var lastSeason = ""
            for p in self.listOrigin {
                if (lastSeason == "") {
                    lastSeason = p.season
                }
                if (self.listSeason.firstIndex(of: p.season) == nil) {
                    self.listSeason.append(p.season)
                }
                if (p.season == lastSeason) {
                    self.listPack.append(p)
                }
            }
            
            self.lblLoading.setHidden(true)
            self.buildSeasonTable()
            
        }
    }
    
    private func buildSeasonTable() {
        tvSeason.setNumberOfRows(listSeason.count, withRowType: "Cell")
        for i in listSeason.indices {
            let r = tvSeason.rowController(at: i) as! SeasonRowController
            r.lblName.setText(listSeason[i])
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let season = self.listSeason[rowIndex]
        self.listPack.removeAll()
        for p in self.listOrigin {
            if (p.season == season) {
                self.listPack.append(p)
            }
        }
        pushController(withName: "SPackageInterfaceController", context: self.listPack)
    }
}
