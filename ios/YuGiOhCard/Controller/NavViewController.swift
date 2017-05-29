//
//  NavViewController.swift
//  YuGiOhCard
//
//  Created by rarnu on 3/26/15.
//  Copyright (c) 2015 rarnu. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

    override func viewWillAppear(_ animated: Bool) {
        UIUtils.setStatusBar(light: true)
        UIUtils.setNavBar(nav: self.navigationBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
