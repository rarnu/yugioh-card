//
//  LimitInterfaceController.swift
//  YuGiOhWatch Extension
//
//  Created by rarnu on 2019/2/7.
//  Copyright © 2019 rarnu. All rights reserved.
//

import WatchKit
import Foundation


class LimitInterfaceController: WKInterfaceController {

    @IBOutlet var tvLimit: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
