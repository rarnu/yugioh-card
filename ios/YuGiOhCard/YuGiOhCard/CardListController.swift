//
//  CardListController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/3.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import YGOAPI
import sfunctional

class CardListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var key = ""
    var currentPage = 1
    var pageCount = 1
    var list = Array<CardInfo>()
    
    var tvCard: UITableView?
    var btnFirst: UIButton?
    var btnPrior: UIButton?
    var btnNext: UIButton?
    var btnLast: UIButton?
    var tvPage: UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvCard = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth(), height: screenHeight() - 36))
        tvCard?.tableFooterView = UIView(frame: CGRect.zero)
        tvCard?.register(CardListCell.classForCoder(), forCellReuseIdentifier: "Cell")
        tvCard?.delegate = self
        tvCard?.dataSource = self
        self.view.addSubview(tvCard!)

        let w = screenWidth() / 6
        btnFirst = UIButton(type: UIButtonType.system)
        btnFirst?.frame = CGRect(x: 0, y: screenHeight() - 36, width: w, height: 36)
        btnFirst?.setTitle("<<", for: UIControlState.normal)
        self.view.addSubview(btnFirst!)
        btnPrior = UIButton(type: UIButtonType.system)
        btnPrior?.frame = CGRect(x: w, y: screenHeight() - 36, width: w, height: 36)
        btnPrior?.setTitle("<", for: UIControlState.normal)
        self.view.addSubview(btnPrior!)
        btnNext = UIButton(type: UIButtonType.system)
        tvPage = UILabel(frame: CGRect(x: w * 2, y: screenHeight() - 36, width: w * 2, height: 36))
        tvPage?.textAlignment = NSTextAlignment.center
        self.view.addSubview(tvPage!)
        btnNext?.frame = CGRect(x: w * 4, y: screenHeight() - 36, width: w, height: 36)
        btnNext?.setTitle(">", for: UIControlState.normal)
        self.view.addSubview(btnNext!)
        btnLast = UIButton(type: UIButtonType.system)
        btnLast?.frame = CGRect(x: w * 5, y: screenHeight() - 36, width: w, height: 36)
        btnLast?.setTitle(">>", for: UIControlState.normal)
        self.view.addSubview(btnLast!)
        
        btnFirst?.addTarget(self, action: #selector(btnFirstClicked(sender:)), for: UIControlEvents.touchDown)
        btnPrior?.addTarget(self, action: #selector(btnPriorClicked(sender:)), for: UIControlEvents.touchDown)
        btnNext?.addTarget(self, action: #selector(btnNextClicked(sender:)), for: UIControlEvents.touchDown)
        btnLast?.addTarget(self, action: #selector(btnLastClicked(sender:)), for: UIControlEvents.touchDown)
        
        searchCommon(akey: key, apage: 1)
    }
    
    private func searchCommon(akey: String, apage: Int) {
        thread {
            let ret = YGOData.searchCommon(akey, page: apage)
            if (ret != nil) {
                self.currentPage = ret!.page
                self.pageCount = ret!.pageCount
                self.list.removeAll()
                for ci in ret!.data {
                    self.list.append(ci)
                }
            }
            self.mainThread {
                self.tvCard?.reloadData()
                self.tvPage?.text = "\(self.currentPage) / \(self.pageCount)"
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
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CardListCell
        let info = self.list[indexPath.row]
        cell.setItem(item: info)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name = self.list[indexPath.row].name
        let hashid = self.list[indexPath.row].hashid
        let c = vc(name: "detail") as! CardDetailController
        c.cardname = name!
        c.hashid = hashid!
        navigationController?.pushViewController(c, animated: true)
    }
    
    @objc func btnFirstClicked(sender: Any?) {
        if (currentPage != 1) {
            currentPage = 1
            searchCommon(akey: key, apage: currentPage)
        }
    }
    
    @objc func btnPriorClicked(sender: Any?) {
        if (currentPage > 1) {
            currentPage -= 1
            searchCommon(akey: key, apage: currentPage)
        }
    }
    
    @objc func btnNextClicked(sender: Any?) {
        if (currentPage < pageCount) {
            currentPage += 1
            searchCommon(akey: key, apage: currentPage)
        }
    }
    
    @objc func btnLastClicked(sender: Any?) {
        if (currentPage != pageCount) {
            currentPage = pageCount
            searchCommon(akey: key, apage: currentPage)
        }
    }

}
