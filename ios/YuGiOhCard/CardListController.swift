//
//  CardListController.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/3.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit
import sfunctional
import YGOAPI2

class CardListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var key = ""
    var currentPage = 1
    var pageCount = 1
    var list = Array<CardInfo2>()
    
    var tvCard: UITableView!
    var btnFirst: UIButton!
    var btnPrior: UIButton!
    var btnNext: UIButton!
    var btnLast: UIButton!
    var tvPage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controlHeight: CGFloat = 48.0
        
        tvCard = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth(), height: screenHeight() - controlHeight))
        tvCard.tableFooterView = UIView(frame: CGRect.zero)
        tvCard.register(CardListCell.classForCoder(), forCellReuseIdentifier: "Cell")
        tvCard.delegate = self
        tvCard.dataSource = self
        tvCard.backgroundColor = UIColor.black
        tvCard.separatorColor = UIColor.darkGray
        tvCard.separatorInset = UIEdgeInsets.zero
        self.view.addSubview(tvCard)
        
        let w: CGFloat = 48.0
        btnFirst = UIButton(type: UIButton.ButtonType.system)
        btnFirst.frame = CGRect(x: 0, y: screenHeight() - controlHeight, width: w, height: controlHeight)
        btnFirst.setImage(UIImage.init(systemName: "backward.fill"), for: UIControl.State.normal)
        
        self.view.addSubview(btnFirst)
        btnPrior = UIButton(type: UIButton.ButtonType.system)
        btnPrior.frame = CGRect(x: w, y: screenHeight() - controlHeight, width: w, height: controlHeight)
        btnPrior.setImage(UIImage.init(systemName: "arrowtriangle.left.fill"), for: UIControl.State.normal)
        self.view.addSubview(btnPrior)
        
        tvPage = UILabel(frame: CGRect(x: w * 2, y: screenHeight() - controlHeight, width: screenWidth() - w * 4, height: controlHeight))
        tvPage.textAlignment = NSTextAlignment.center
        tvPage.textColor = UIColor.white
        self.view.addSubview(tvPage)
        
        btnNext = UIButton(type: UIButton.ButtonType.system)
        btnNext.frame = CGRect(x: screenWidth() - w * 2, y: screenHeight() - controlHeight, width: w, height: controlHeight)
        btnNext.setImage(UIImage.init(systemName: "arrowtriangle.right.fill"), for: UIControl.State.normal)
        self.view.addSubview(btnNext)
        
        btnLast = UIButton(type: UIButton.ButtonType.system)
        btnLast.frame = CGRect(x: screenWidth() - w, y: screenHeight() - controlHeight, width: w, height: controlHeight)
        btnLast.setImage(UIImage.init(systemName: "forward.fill"), for: UIControl.State.normal)
        self.view.addSubview(btnLast)
        
        btnFirst.addTarget(self, action: #selector(btnFirstClicked(sender:)), for: UIControl.Event.touchDown)
        btnPrior.addTarget(self, action: #selector(btnPriorClicked(sender:)), for: UIControl.Event.touchDown)
        btnNext.addTarget(self, action: #selector(btnNextClicked(sender:)), for: UIControl.Event.touchDown)
        btnLast.addTarget(self, action: #selector(btnLastClicked(sender:)), for: UIControl.Event.touchDown)
        
        searchCommon(akey: key, apage: 1)
    }
    
    private func searchCommon(akey: String, apage: Int) {
        YGOData2.searchCommon(akey, apage) { r in
            self.currentPage = r.page
            self.pageCount = r.pageCount
            self.list.removeAll()
            for ci in r.data {
                self.list.append(ci)
            }
            self.mainThread {
                self.tvCard.reloadData()
                self.tvPage.text = "\(self.currentPage) / \(self.pageCount)"
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
        c.cardname = name
        c.hashid = hashid
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
