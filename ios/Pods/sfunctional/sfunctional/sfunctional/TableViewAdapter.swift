//
//  TableViewAdapter.swift
//  sfunctional
//
//  Created by rarnu on 2018/7/18.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

open class AdapterCell<T>: UITableViewCell {
    
    private var innerItem: T?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }
    
    open func layout() {
        // XXX: override your own layout
        fatalError("Subclasses need to implement the `layout()` method.")
    }
    
    open func innerSetItem(a: T?) {
        innerItem = a
        setItem(item: a)
    }

    open func setItem(item: T?) {
        // XXX: override your own data setter
        fatalError("Subclasses need to implement the `setItem()` method.")
    }
    
    public func getItem() -> T? {
        return innerItem
    }
}

public protocol AdapterTableViewDelegate {
    func tableView<T>(_ tableView: AdapterTableView<T>, clickAt indexPath: IndexPath)
    func tableView<T>(_ tableView: AdapterTableView<T>, longPressAt indexPath: IndexPath)
}

public protocol AdapterTableViewRefreshDelegate {
    func tableView<T>(_ tableView: AdapterTableView<T>, pulldown list: inout Array<T>)
}

open class AdapterTableView<T>: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    public let CELLNAME = "Cell"
    public var list = Array<T>()
    public var adapterDelegate: AdapterTableViewDelegate? = nil
    public var refreshDelegate: AdapterTableViewRefreshDelegate? = nil
    
    private var refreshText = ""
    private var refreshingText = ""
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load()
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        load()
    }
    
    public init(frame: CGRect) {
        super.init(frame: frame, style: UITableView.Style.plain)
        load()
    }
    
    public func assignList(arr: Array<T>) {
        list.removeAll()
        for t in arr {
            list.append(t)
        }
    }
    
    @available(iOS 10, *)
    public func pulldownRefresh(_ enabled: Bool, base: String = "Pulldown to refresh", refreshing: String = "Refreshing...") {
        refreshText = base
        refreshingText = refreshing
        if (!enabled) {
            self.refreshControl = nil
        } else {
            let ref = UIRefreshControl()
            ref.attributedTitle = NSAttributedString(string: refreshText)
            ref.addTarget(self, action: #selector(onRefresh(_:)), for: UIControl.Event.valueChanged)
            self.refreshControl = ref
        }
    }
    
    @available(iOS 10, *)
    @objc private func onRefresh(_ sender: Any?) {
        if (self.refreshControl != nil) {
            if (self.refreshControl!.isRefreshing) {
                self.refreshControl!.attributedTitle = NSAttributedString(string: refreshingText)
                if (self.refreshDelegate != nil) {
                    self.refreshDelegate!.tableView(self, pulldown: &self.list)
                }
                self.refreshControl!.attributedTitle = NSAttributedString(string: refreshText)
                self.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func load() {
        tableFooterView = UIView(frame: CGRect.zero)
        delegate = self
        dataSource = self
        register(cellClass(), forCellReuseIdentifier: CELLNAME)
        let longEvent = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        longEvent.minimumPressDuration = 1.5
        self.addGestureRecognizer(longEvent)
    }
    
    @objc private func longPressAction(_ gesture: UILongPressGestureRecognizer) {
        if (gesture.state == UIGestureRecognizer.State.began) {
            let p = gesture.location(in: self)
            let idx = self.indexPathForRow(at: p)
            if (idx == nil) {
                return
            }
            self.deselectRow(at: idx!, animated: true)
            if (self.adapterDelegate != nil) {
                self.adapterDelegate?.tableView(self, longPressAt: idx!)
            }
        }
    }
    
    open func cellClass() -> Swift.AnyClass? {
        fatalError("Subclasses need to implement the `register()` method.")
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELLNAME, for: indexPath) as! AdapterCell<T>
        cell.innerSetItem(a: list[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (self.adapterDelegate != nil) {
            self.adapterDelegate?.tableView(self, clickAt: indexPath)
        }
    }
    
    
}
