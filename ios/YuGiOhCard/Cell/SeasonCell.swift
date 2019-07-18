//
//  SeasonCell.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/10.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import commonios

class SeasonCell: AdapterCell<String> {

    var lblName: UILabel!

    override func layout() {
        self.backgroundColor = UIColor.black
        lblName = UILabel(frame: CGRect(x: 8, y: 0, width: 80, height: 40))
        lblName.font = UIFont.systemFont(ofSize: 12)
        lblName.textColor = UIColor.white
        self.addSubview(lblName!)
    }
    
    override func setItem(item: String?) {
        lblName.text = item
    }
    
    func setHighlight(h: Bool) {
        lblName.textColor = h ? self.tintColor : UIColor.lightGray
    }
    

}
