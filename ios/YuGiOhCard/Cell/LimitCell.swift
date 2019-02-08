//
//  LimitCell.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/9.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import sfunctional
import YGOAPI2

class LimitCell: AdapterCell<LimitInfo2> {

    var lblType: UILabel?
    var lblName: UILabel?
    var lblLimit: UILabel?
    
    override func layout() {
        lblType = UILabel(frame: CGRect(x: 8, y: 4, width: 22, height: 32))
        lblName = UILabel(frame: CGRect(x: 38, y: 0, width: screenWidth() - 128, height: 40))
        lblLimit = UILabel(frame: CGRect(x: screenWidth() - 80, y: 0, width: 72, height: 40))
        lblLimit?.textAlignment = NSTextAlignment.right
        self.addSubview(lblType!)
        self.addSubview(lblName!)
        self.addSubview(lblLimit!)
    }
    
    override func setItem(item: LimitInfo2?) {
        if (item != nil) {
            lblType?.backgroundColor = UIColor().parseString(item!.color)
            lblName?.text = item!.name
            switch item!.limit {
            case 0:
                lblLimit?.text = "禁止"
                lblLimit?.textColor = UIColor.red
                break
            case 1:
                lblLimit?.text = "限制"
                lblLimit?.textColor = UIColor.orange
                break
            default:
                lblLimit?.text = "准限制"
                lblLimit?.textColor = UIColor.green
                break
            }
        }
    }
}
