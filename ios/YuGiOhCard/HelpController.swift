//
//  HelpController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/18.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import TangramKit
import sfunctional

class HelpController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sv = UIScrollView(frame: CGRect(x: 8, y: 8, width: screenWidth() - 16, height: screenHeight() - 16))
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        self.view.addSubview(sv)
        // help
        let imgIcon = UIImageView(frame: CGRect(x: 8, y: 8, width: 48, height: 48))
        imgIcon.contentMode = UIView.ContentMode.scaleAspectFit
        imgIcon.image = UIImage(named: "AppIcon")
        sv.addSubview(imgIcon)
        let tvTitle = UILabel(frame: CGRect(x: 64, y: 8, width: screenWidth() - 72, height: 24))
        tvTitle.text = "YuGiOh Card"
        tvTitle.textColor = UIColor.white
        sv.addSubview(tvTitle)
        let tvVersion = UILabel(frame: CGRect(x: 64, y: 32, width: screenWidth() - 72, height: 32))
        tvVersion.text = "5.0.1"
        tvVersion.textColor = UIColor.white
        sv.addSubview(tvVersion)
        let vLine = UIView(frame: CGRect(x: 8, y: 64, width: screenWidth() - 16, height: 1))
        vLine.backgroundColor = UIColor.lightGray
        sv.addSubview(vLine)
        
        let lblAuthor = UIButton(type: UIButton.ButtonType.system)
        lblAuthor.frame = CGRect(x: 8, y: 72, width: screenWidth() - 16, height: 32)
        lblAuthor.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        lblAuthor.setTitle("软件作者: rarnu", for: UIControl.State.normal)
        sv.addSubview(lblAuthor)
        
        let lblOurocg = UIButton(type: UIButton.ButtonType.system)
        lblOurocg.frame = CGRect(x: 8, y: 104, width: screenWidth() - 16, height: 32)
        lblOurocg.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        lblOurocg.setTitle("数据来源: 中国OCG工作室", for: UIControl.State.normal)
        sv.addSubview(lblOurocg)
        
        let lblRarnu = UIButton(type: UIButton.ButtonType.system)
        lblRarnu.frame = CGRect(x: 8, y: 136, width: screenWidth() - 16, height: 32)
        lblRarnu.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        lblRarnu.setTitle("卡查开源: github.com/rarnu/yugioh-card", for: UIControl.State.normal)
        sv.addSubview(lblRarnu)
        
        let vLine2 = UIView(frame: CGRect(x: 8, y: 168, width: screenWidth() - 16, height: 1))
        vLine2.backgroundColor = UIColor.lightGray
        sv.addSubview(vLine2)
        
        // events
        lblOurocg.addTarget(self, action: #selector(btnOurocgClicked(sender:)), for: UIControl.Event.touchDown)
        lblRarnu.addTarget(self, action: #selector(btnRarnuClicked(sender:)), for: UIControl.Event.touchDown)
        lblAuthor.addTarget(self, action: #selector(btnAuthorClicked(sender:)), for: UIControl.Event.touchDown)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func btnAuthorClicked(sender: UIButton) {
        openUrl("http://scarlett.vip/yugioh")
    }
    
    @objc func btnOurocgClicked(sender: UIButton) {
        openUrl("https://www.ourocg.cn")
    }

    @objc func btnRarnuClicked(sender: UIButton) {
        openUrl("https://github.com/rarnu/yugioh-card")
    }
    
    private func openUrl(_ aurl: String) {
        let u = URL(string: aurl)
        if (u != nil) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(u!, options:[:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(u!)
            }
            
        }
    }
}
