//
//  PackCell.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/10.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import YGOAPI
import sfunctional

class PackCell: AdapterCell<PackageInfo> {

    var lblName: UILabel?
    
    override func layout() {
        lblName = UILabel(frame: CGRect(x: 8, y: 0, width: screenWidth() - 81, height: 40))
        lblName?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(lblName!)
    }
    
    override func setItem(item: PackageInfo?) {
        if (item != nil) {
            lblName?.text = item!.name
        }
    }
}
