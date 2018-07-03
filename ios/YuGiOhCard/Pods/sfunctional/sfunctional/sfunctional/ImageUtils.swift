//
//  ImageUtils.swift
//  sfunctional
//
//  Created by rarnu on 27/03/2018.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

public extension UIImage {
    
    class func loadFromBundle(_ filename: String) -> UIImage? {
        let file = Bundle.main.path(forResource: filename, ofType: "")
        if (file != nil) {
            return UIImage(contentsOfFile: file!)
        } else {
            return nil
        }
    }
    
    func scale(_ scale: CGFloat) -> UIImage {
        let w = size.width * scale
        let h = size.height * scale
        let newSize = CGSize(width: w, height: h)
        let img = UIImage()
        UIGraphicsBeginImageContext(newSize)
        img.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
        UIGraphicsEndImageContext()
        return img
    }
    
    func scale(_ newSize: CGSize) -> UIImage {
        let img = UIImage()
        UIGraphicsBeginImageContext(newSize)
        img.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        UIGraphicsEndImageContext()
        return img
    }
    
    func save(_ filename: String, format: String = "PNG") {
        if (format == "PNG") {
            let d = UIImagePNGRepresentation(self)! as NSData
            d.write(toFile: filename, atomically: true)
        } else if (format == "JPG") {
            let d = UIImageJPEGRepresentation(self, 1.0)! as NSData
            d.write(toFile: filename, atomically: true)
        }
    }

    func blackWhite() -> UIImage {
        let imageData = UIImagePNGRepresentation(self)
        let inputImage = CoreImage.CIImage(data: imageData!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CIPhotoEffectNoir")
        filter!.setValue(inputImage, forKey: kCIInputImageKey)
        let outputImage = filter!.outputImage!
        let outImage = context.createCGImage(outputImage, from: outputImage.extent)
        return UIImage(cgImage: outImage!)
    }
    
    func blur(_ level: CGFloat) -> UIImage {
        let ctx = CIContext(options: nil)
        let inputImage = CIImage(image: self)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(level, forKey: "inputRadius")
        let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage
        let cg = ctx.createCGImage(result, from: result.extent)! as CGImage
        return UIImage(cgImage: cg)
    }
    
    func rotate90Clockwise() -> UIImage? {
        var ret: UIImage? = nil
        switch (self.imageOrientation) {
        case UIImageOrientation.up:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.right)
            break
        case UIImageOrientation.down:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.left)
            break
        case UIImageOrientation.left:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.up)
            break
        case UIImageOrientation.right:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.down)
            break
        case UIImageOrientation.upMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.leftMirrored)
            break
        case UIImageOrientation.downMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.rightMirrored)
            break
        case UIImageOrientation.leftMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.downMirrored)
            break
        case UIImageOrientation.rightMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.upMirrored)
            break
        }
        return ret
    }
    
    func rotate90CounterClockwise() -> UIImage? {
        var ret: UIImage? = nil
        switch (self.imageOrientation) {
        case UIImageOrientation.up:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.left)
            break
        case UIImageOrientation.down:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.right)
            break
        case UIImageOrientation.left:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.down)
            break
        case UIImageOrientation.right:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.up)
            break
        case UIImageOrientation.upMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.rightMirrored)
            break
        case UIImageOrientation.downMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.leftMirrored)
            break
        case UIImageOrientation.leftMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.upMirrored)
            break
        case UIImageOrientation.rightMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.downMirrored)
            break
        }
        return ret
    }
    
    func rotate180() -> UIImage? {
        var ret: UIImage? = nil
        switch (self.imageOrientation) {
        case UIImageOrientation.up:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.down)
            break
        case UIImageOrientation.down:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.up)
            break
        case UIImageOrientation.left:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.right)
            break
        case UIImageOrientation.right:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.left)
            break
        case UIImageOrientation.upMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.downMirrored)
            break
        case UIImageOrientation.downMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.upMirrored)
            break
        case UIImageOrientation.leftMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.rightMirrored)
            break
        case UIImageOrientation.rightMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.leftMirrored)
            break
        }
        return ret
    }
    
    func rotateOrigin() -> UIImage {
        let size = CGSize(width:self.size.width * scale, height: self.size.height * scale)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.clear(CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let ret = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return ret
    }
    
    func flipHorizontal() -> UIImage? {
        var ret: UIImage? = nil
        switch (self.imageOrientation) {
        case UIImageOrientation.up:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.upMirrored)
            break
        case UIImageOrientation.down:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.downMirrored)
            break
        case UIImageOrientation.left:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.rightMirrored)
            break
        case UIImageOrientation.right:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.leftMirrored)
            break
        case UIImageOrientation.upMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.up)
            break
        case UIImageOrientation.downMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.down)
            break
        case UIImageOrientation.leftMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.right)
            break
        case UIImageOrientation.rightMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.left)
            break
        }
        return ret
    }
    
    func flipVertical() -> UIImage? {
        var ret: UIImage? = nil
        switch (self.imageOrientation) {
        case UIImageOrientation.up:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.downMirrored)
            break
        case UIImageOrientation.down:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.upMirrored)
            break
        case UIImageOrientation.left:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.leftMirrored)
            break
        case UIImageOrientation.right:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.rightMirrored)
            break
        case UIImageOrientation.upMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.down)
            break
        case UIImageOrientation.downMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.up)
            break
        case UIImageOrientation.leftMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.left)
            break
        case UIImageOrientation.rightMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImageOrientation.right)
            break
        }
        return ret
    }
    
    func flipAll() -> UIImage? {
        return rotate180()
    }
    
}
