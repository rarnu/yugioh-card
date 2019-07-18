//
//  LimitController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/9.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import YGOAPI2
import commonios

class LimitController: UITableViewController {

    var list = Array<LimitInfo2>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(LimitCell.classForCoder(), forCellReuseIdentifier: "Cell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.backgroundColor = UIColor.black
        self.tableView.separatorColor = UIColor.darkGray
        self.tableView.separatorInset = UIEdgeInsets.zero
        YGOData2.limit() { l in
            self.list = l
            mainThread {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LimitCell
        cell.setItem(item: list[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let item = list[indexPath.row]
        let c = vc(name: "detail") as! CardDetailController
        c.cardname = item.name
        c.hashid = item.hashid
        navigationController?.pushViewController(c, animated: true)
    }

}
