//
//  PopupViewController.swift
//  sfunctional
//
//  Created by rarnu on 2018/9/11.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

open class PopupViewController: UIViewController {

    private var baseView: UIView?
    private var vAlpha: CGFloat = 0.5
    private var vRadius: CGFloat = 25.0
    private var vWidth: CGFloat = 0.0
    private var vHeight: CGFloat = 0.0
    
    public init(width: CGFloat, height: CGFloat, alpha: CGFloat = 0.5, radius: CGFloat = 25.0) {
        super.init(nibName: nil, bundle: nil)
        vWidth = width
        vHeight = height
        vAlpha = alpha
        vRadius = radius
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1, alpha: vAlpha)
        self.baseView = UIView(frame: CGRect(x: 0, y: 0, width: vWidth, height: vHeight))
        self.baseView?.backgroundColor = UIColor.white
        self.baseView?.layer.cornerRadius = vRadius
        self.baseView?.layer.borderColor = UIColor.lightGray.cgColor
        self.baseView?.layer.borderWidth = 1
        self.baseView?.layer.position = self.view.center
        self.view.addSubview(self.baseView!)
        layout(base: self.baseView!)
    }
    
    open func layout(base: UIView) {
        fatalError("Subclasses need to implement the `layout()` method.")
    }    
}
