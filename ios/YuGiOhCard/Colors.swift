//
//  Colors.swift
//  YuGiOhCard
//
//  Created by rarnu on 2019/9/17.
//  Copyright © 2019 rarnu. All rights reserved.
//

import UIKit

let navColor = UIColor(red: 33 / 255.0, green: 33 / 255.0, blue: 33.0 / 255.0, alpha: 1)
let darkColor = UIColor(red: 48.0 / 255.0, green: 48.0 / 255.0, blue: 48.0 / 255.0, alpha: 1)

extension UIImage {
    class func color(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
