//
//  SPackageInterfaceController.swift
//  YuGiOhWatch Extension
//
//  Created by rarnu on 2019/2/8.
//  Copyright © 2019 rarnu. All rights reserved.
//

import WatchKit
import Foundation
import YGOAPI2Watch

class PackageRowController: NSObject {
    @IBOutlet var lblName: WKInterfaceLabel!
}

class SPackageInterfaceController: WKInterfaceController {

    @IBOutlet var tvPackage: WKInterfaceTable!
    var listPack = Array<PackageInfo2>()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.listPack = context as! Array<PackageInfo2>
        self.buildPackageTable()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {        
        super.didDeactivate()
    }
    
    private func buildPackageTable() {
        tvPackage.setNumberOfRows(listPack.count, withRowType: "Cell")
        for i in listPack.indices {
            let r = tvPackage.rowController(at: i) as! PackageRowController
            r.lblName.setText(listPack[i].name)
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let url = self.listPack[rowIndex].url
        pushController(withName: "PackCardsInterfaceController", context: url)
    }

}
