//
//  UIScrollView+UITouch.swift
//  YuGiOhCard
//
//  Created by rarnu on 2018/7/12.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
    }
    
}
