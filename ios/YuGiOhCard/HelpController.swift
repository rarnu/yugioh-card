//
//  HelpController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/18.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import TangramKit
import commonios

class HelpController: UIViewController {
    
    private func makeLine(_ base: TGLinearLayout, _ top: CGFloat) {
        let line = UIView()
        line.tg_width.equal(90%)
        line.tg_height.equal(1)
        line.backgroundColor = UIColor.darkGray
        line.tg_centerX.equal(0)
        line.tg_top.equal(top)
        base.addSubview(line)
    }
    
    private func makeVLine(_ base: TGLinearLayout) {
        let line = UIView()
        line.tg_width.equal(1)
        line.tg_height.equal(16)
        line.backgroundColor = UIColor.darkGray
        line.tg_left.equal(8)
        line.tg_right.equal(8)
        base.addSubview(line)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView(frame: CGRect(x: 8, y: 8, width: screenWidth() - 16, height: screenHeight() - 16))
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        self.view.addSubview(sv)
        
        let layMain = TGLinearLayout(.vert)
        layMain.tg_width.equal(100%)
        layMain.tg_height.equal(100%)
        sv.addSubview(layMain)
        
        let imgIcon = UIImageView()
        imgIcon.tg_width.equal(64)
        imgIcon.tg_height.equal(64)
        imgIcon.contentMode = UIView.ContentMode.scaleAspectFit
        imgIcon.image = UIImage(named: "AppIcon")
        imgIcon.tg_centerX.equal(0)
        imgIcon.tg_top.equal(28)
        layMain.addSubview(imgIcon)
        
        let tvTitle = UILabel()
        tvTitle.tg_width.equal(.wrap)
        tvTitle.tg_height.equal(.wrap)
        tvTitle.text = "YuGiOh Card"
        tvTitle.font = UIFont.boldSystemFont(ofSize: 18)
        tvTitle.textColor = UIColor.white
        tvTitle.tg_centerX.equal(0)
        tvTitle.tg_top.equal(8)
        layMain.addSubview(tvTitle)
        
        let layDesc = TGLinearLayout(.horz)
        layDesc.tg_width.equal(.wrap)
        layDesc.tg_height.equal(16)
        layDesc.tg_centerX.equal(0)
        layDesc.tg_top.equal(8)
        layMain.addSubview(layDesc)
        
        // TODO: add desc
        let tvIos = UILabel()
        tvIos.tg_width.equal(.wrap)
        tvIos.tg_height.equal(16)
        tvIos.text = "iOS 原生应用"
        tvIos.textColor = UIColor.green
        tvIos.font = UIFont.systemFont(ofSize: 14)
        layDesc.addSubview(tvIos)
        makeVLine(layDesc)
        let tvSingle = UILabel()
        tvSingle.tg_width.equal(.wrap)
        tvSingle.tg_height.equal(16)
        tvSingle.text = "独立平台"
        tvSingle.textColor = UIColor.green
        tvSingle.font = UIFont.systemFont(ofSize: 14)
        layDesc.addSubview(tvSingle)
        makeVLine(layDesc)
        let tvOpen = UILabel()
        tvOpen.tg_width.equal(.wrap)
        tvOpen.tg_height.equal(16)
        tvOpen.text = "完全开源"
        tvOpen.textColor = UIColor.green
        tvOpen.font = UIFont.systemFont(ofSize: 14)
        layDesc.addSubview(tvOpen)
        
        
        let tvDesc = UILabel()
        tvDesc.tg_width.equal(.wrap)
        tvDesc.tg_height.equal(.wrap)
        tvDesc.text = "游戏王卡片查询器，数据来源 ourocg.cn"
        tvDesc.textColor = UIColor.lightGray
        tvDesc.tg_centerX.equal(0)
        tvDesc.tg_top.equal(8)
        tvDesc.font = UIFont.systemFont(ofSize: 14)
        layMain.addSubview(tvDesc)
        
        makeLine(layMain, 16)
        let layTool = TGLinearLayout(.horz)
        layTool.tg_width.equal(90%)
        layTool.tg_height.equal(.wrap)
        layTool.tg_centerX.equal(0)
        layTool.tg_top.equal(16)
        layMain.addSubview(layTool)
        
        let tvTool = UILabel()
        tvTool.tg_width.equal(20%)
        tvTool.tg_height.equal(.wrap)
        tvTool.text = "服务类型"
        tvTool.textColor = UIColor.white
        tvTool.font = UIFont.systemFont(ofSize: 14)
        layTool.addSubview(tvTool)
        
        let tvToolValue = UILabel()
        tvToolValue.tg_width.equal(80%)
        tvToolValue.tg_height.equal(.wrap)
        tvToolValue.text = "游戏工具类"
        tvToolValue.textColor = UIColor.lightGray
        tvToolValue.font = UIFont.systemFont(ofSize: 14)
        layTool.addSubview(tvToolValue)
        
        makeLine(layMain, 16)
        
        let layGithub = TGLinearLayout(.horz)
        layGithub.tg_width.equal(90%)
        layGithub.tg_height.equal(.wrap)
        layGithub.tg_centerX.equal(0)
        layGithub.tg_top.equal(16)
        layMain.addSubview(layGithub)
        
        let tvGithub = UILabel()
        tvGithub.tg_width.equal(20%)
        tvGithub.tg_height.equal(16)
        tvGithub.text = "开源信息"
        tvGithub.textColor = UIColor.white
        tvGithub.font = UIFont.systemFont(ofSize: 14)
        layGithub.addSubview(tvGithub)
        
        let tvGithubValue = UIButton(type: UIButton.ButtonType.system)
        tvGithubValue.tg_width.equal(80%)
        tvGithubValue.tg_height.equal(16)
        tvGithubValue.setTitle("github.com/rarnu/yugioh-card", for: UIControl.State.normal)
        tvGithubValue.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        tvGithubValue.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tvGithubValue.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        layGithub.addSubview(tvGithubValue)
        
        makeLine(layMain, 16)
        
        // event
        tvGithubValue.addTarget(self, action: #selector(btnGithubClicked(sender:)), for: UIControl.Event.touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func btnGithubClicked(sender: Any) {
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
