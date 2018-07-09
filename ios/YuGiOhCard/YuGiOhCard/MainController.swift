//
//  ViewController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/6/29.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import YGOAPI
import sfunctional

class MainController: UIViewController {

    var edtSearch: UITextField?
    var btnSearch: UIButton?
    var btnAdvSearch: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth(), height: screenHeight()))
        self.view.addSubview(sv)
        edtSearch = UITextField(frame: CGRect(x: 8, y: 8, width: screenWidth() - 140, height: 36))
        edtSearch?.borderStyle = UITextBorderStyle.roundedRect
        sv.addSubview(edtSearch!)
        btnSearch = UIButton(type: UIButtonType.system)
        btnSearch?.frame = CGRect(x: screenWidth() - 120, y: 8, width: 40, height: 36)
        btnSearch?.setTitle("搜索", for: UIControlState.normal)
        sv.addSubview(btnSearch!)
        btnAdvSearch = UIButton(type: UIButtonType.system)
        btnAdvSearch?.frame = CGRect(x: screenWidth() - 80, y: 8, width: 80, height: 36)
        btnAdvSearch?.setTitle("高级搜索", for: UIControlState.normal)
        sv.addSubview(btnAdvSearch!)
        btnSearch?.addTarget(self, action: #selector(btnSearchClicked(sender:)), for: UIControlEvents.touchDown)
        btnAdvSearch?.addTarget(self, action: #selector(btnAdvSearchClicked(sender:)), for: UIControlEvents.touchDown)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func btnSearchClicked(sender: Any?) {
        // search clicked
        let key = edtSearch?.text
        if (key == nil || key == "") {
            self.view.toast(msg: "不能搜索空关键字")
            return
        }
        let c = vc(name: "cardlist") as! CardListController
        c.type = 0
        c.key = key!
        navigationController?.pushViewController(c, animated: true)
    }
    
    @objc func btnAdvSearchClicked(sender: Any?) {
        // TODO: adv search clicked
    }
}

