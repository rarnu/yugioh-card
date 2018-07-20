//
//  PackDetailController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/10.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import YGOAPI
import sfunctional

class PackDetailController: UITableViewController {

    var name = ""
    var url = ""
    
    var list = Array<CardInfo>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = name
        self.tableView.register(CardListCell.classForCoder(), forCellReuseIdentifier: "Cell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        thread {
            let ret = YGOData.packageDetail(self.url)
            if (ret != nil) {
                self.list.removeAll()
                for ci in ret!.data {
                    self.list.append(ci)
                }
            }
            self.mainThread {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CardListCell
        cell.setItem(item: list[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name = self.list[indexPath.row].name
        let hashid = self.list[indexPath.row].hashid
        let c = vc(name: "detail") as! CardDetailController
        c.cardname = name!
        c.hashid = hashid!
        navigationController?.pushViewController(c, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    

}
