//
//  CardListCell.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/3.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import commonios
import YGOAPI2

class CardListCell: AdapterCell<CardInfo2> {
    
    var tvCardName: UILabel!
    var tvCardJapname: UILabel!
    var tvCardEnname: UILabel!
    var tvCardType: UILabel!
    var ivCardImg: UIImageView!
    
    override func layout() {
        self.backgroundColor = UIColor.black
        self.tintColor = UIColor.white
        tvCardName = UILabel() ~>> {
            $0.frame = CGRect(x: 8, y: 0, width: screenWidth() - 86, height: 25)
            $0.textAlignment = NSTextAlignment.left
            $0.textColor = UIColor.white
            return $0
        }
        tvCardJapname = UILabel() ~>> {
            $0.frame = CGRect(x: 8, y: 25, width: screenWidth() - 86, height: 25)
            $0.textAlignment = NSTextAlignment.left
            $0.textColor = UIColor.white
            return $0
        }
        tvCardEnname = UILabel() ~>> {
            $0.frame = CGRect(x: 8, y: 50, width: screenWidth() - 86, height: 25)
            $0.textAlignment = NSTextAlignment.left
            $0.textColor = UIColor.white
            return $0
        }
        tvCardType = UILabel() ~>> {
            $0.frame = CGRect(x: 8, y: 75, width: screenWidth() - 86, height: 25)
            $0.textAlignment = NSTextAlignment.left
            $0.textColor = UIColor.white
            return $0
        }
        ivCardImg = UIImageView() ~>> {
            $0.frame = CGRect(x: screenWidth() - 78, y: 4, width: 70, height: 92)
            $0.contentMode = UIView.ContentMode.scaleAspectFit
            return $0
        }
        self.addSubview(tvCardName)
        self.addSubview(tvCardJapname)
        self.addSubview(tvCardEnname)
        self.addSubview(tvCardType)
        self.addSubview(ivCardImg)
    }
    
    override func setItem(item: CardInfo2?) {
        if (item != nil) {
            tvCardName.text = "中文名称: \(item!.name)"
            tvCardJapname.text = "日文名称: \(item!.japname)"
            tvCardEnname.text = "英文名称: \(item!.enname)"
            tvCardType.text = item!.cardtype
            // load image
            let localfile = documentPath(true) + "\(item!.cardid)"
            if (FileManager.default.fileExists(atPath: localfile)) {
                ivCardImg.image = UIImage(contentsOfFile: localfile)
            } else {
                download(String(format: RES_URL, item!.cardid), localfile) { (state, _, _, _) in
                    if (state == DownloadState.Complete) {
                        if (FileManager.default.fileExists(atPath: localfile)) {
                            mainThread {
                                self.ivCardImg?.image = UIImage(contentsOfFile: localfile)
                            }
                        }
                    }
                }
            }
        }
    }
}
