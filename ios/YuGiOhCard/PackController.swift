//
//  PackController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/10.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import sfunctional
import YGOAPI2

class PackController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listSeason = Array<String>()
    var listPack = Array<PackageInfo2>()
    var listOrigin = Array<PackageInfo2>()
    
    var lvPack: UITableView!
    var lvSeason: UITableView!
    
    private var highlight = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lvSeason = UITableView(frame: CGRect(x: 0, y: 0, width: 80, height: screenHeight()))
        lvSeason.register(SeasonCell.classForCoder(), forCellReuseIdentifier: "Cell")
        lvSeason.tableFooterView = UIView(frame: CGRect.zero)
        lvSeason.delegate = self
        lvSeason.dataSource = self
        lvSeason.backgroundColor = UIColor.black
        lvSeason.separatorColor = UIColor.darkGray
        lvSeason.separatorInset = UIEdgeInsets.zero
        self.view.addSubview(lvSeason)
        
        let v = UIView(frame: CGRect(x: 80, y: statusbarSize().height + navigationbarHeight(), width: 1, height: screenHeight()))
        v.backgroundColor = UIColor.darkGray
        self.view.addSubview(v)
        
        lvPack = UITableView(frame: CGRect(x: 81, y: 0, width: screenWidth() - 81, height: screenHeight()))
        lvPack.register(PackCell.classForCoder(), forCellReuseIdentifier: "Cell")
        lvPack.tableFooterView = UIView(frame: CGRect.zero)
        lvPack.delegate = self
        lvPack.dataSource = self
        lvPack.backgroundColor = UIColor.black
        lvPack.separatorColor = UIColor.darkGray
        lvPack.separatorInset = UIEdgeInsets.zero
        self.view.addSubview(lvPack)
        
        YGOData2.packageList() { l in
            self.listOrigin = l
            self.listSeason.removeAll()
            self.listPack.removeAll()
            var lastSeason = ""
            for p in self.listOrigin {
                if (lastSeason == "") {
                    lastSeason = p.season
                }
                if (self.listSeason.firstIndex(of: p.season) == nil) {
                    self.listSeason.append(p.season)
                }
                if (p.season == lastSeason) {
                    self.listPack.append(p)
                }
            }
            
            self.mainThread {
                self.lvSeason.reloadData()
                self.lvPack.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == lvSeason) {
            return listSeason.count
        } else {
            return listPack.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == lvSeason) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SeasonCell
            cell.setItem(item: listSeason[indexPath.row])
            cell.setHighlight(h: highlight == indexPath.row)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PackCell
            cell.setItem(item: listPack[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == lvSeason) {
            let season = listSeason[indexPath.row]
            highlight = indexPath.row
            thread {
                self.listPack.removeAll()
                for p in self.listOrigin {
                    if (p.season == season) {
                        self.listPack.append(p)
                    }
                }
                self.mainThread {
                    self.lvPack.reloadData()
                    self.lvSeason.reloadData()
                }
            }
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            let pack = listPack[indexPath.row]
            let c = vc(name: "packdetail") as! PackDetailController
            c.name = pack.abbr
            c.url = pack.url
            navigationController?.pushViewController(c, animated: true)
            
        }
        
    }
}
