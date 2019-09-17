//
//  PackCell.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/10.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import commonios
import YGOAPI2

class PackCell: AdapterCell<PackageInfo2> {

    var lblName: UILabel!
    
    override func layout() {
        self.backgroundColor = darkColor
        lblName = UILabel() ~>> {
            $0.frame = CGRect(x: 8, y: 0, width: screenWidth() - 81, height: 40)
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.white
            return $0
        }
        
        self.addSubview(lblName)
    }
    
    override func setItem(item: PackageInfo2?) {
        if (item != nil) {
            lblName.text = item!.name
        }
    }
}
