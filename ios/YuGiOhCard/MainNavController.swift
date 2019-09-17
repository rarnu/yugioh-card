//
//  MainNavController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2019/7/11.
//  Copyright © 2019 rarnu. All rights reserved.
//

import UIKit

class MainNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let bar = UINavigationBar.appearance() as UINavigationBar
        bar.setBackgroundImage(UIImage.color(navColor), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        super.viewWillAppear(animated)
    }
}
