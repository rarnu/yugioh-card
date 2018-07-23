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
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        fatalError("Subclasses need to implement the `lasetItemyout()` method.")
    }
    
    public func getItem() -> T? {
        return innerItem
    }
}

open class AdapterTableView<T>: UITableView, UITableViewDelegate, UITableViewDataSource {

    public let CELLNAME = "Cell"
    
    public var list = Array<T>()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load()
    }
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        load()
    }
    
    public init(frame: CGRect) {
        super.init(frame: frame, style: UITableViewStyle.plain)
        load()
    }
    
    private func load() {
        tableFooterView = UIView(frame: CGRect.zero)
        delegate = self
        dataSource = self
        register()
    }
    
    open func register() {
        // XXX: override this, must pass a cell extened AdapterCell
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
}
