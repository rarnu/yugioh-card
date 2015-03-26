//
//  LimitTabViewController.swift
//  YuGiOhCard
//
//  Created by rarnu on 3/26/15.
//  Copyright (c) 2015 rarnu. All rights reserved.
//

import UIKit

class LimitTabViewController: UITabBarController {

    override func viewWillAppear(animated: Bool) {
        UIUtils.setStatusBar(true)
        UIUtils.setNavBar(self.navigationController!.navigationBar)
        UIUtils.setTabBar(self.tabBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
