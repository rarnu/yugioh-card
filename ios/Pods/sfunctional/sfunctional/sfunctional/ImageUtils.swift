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
            let d = self.pngData()! as NSData // UIImagePNGRepresentation(self)! as NSData
            d.write(toFile: filename, atomically: true)
        } else if (format == "JPG") {
            let d = self.jpegData(compressionQuality: 1.0)! as NSData // UIImageJPEGRepresentation(self, 1.0)! as NSData
            d.write(toFile: filename, atomically: true)
        }
    }

    func blackWhite() -> UIImage {
        let imageData = self.pngData() // UIImagePNGRepresentation(self)
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
        case UIImage.Orientation.up:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.right)
            break
        case UIImage.Orientation.down:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.left)
            break
        case UIImage.Orientation.left:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.up)
            break
        case UIImage.Orientation.right:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.down)
            break
        case UIImage.Orientation.upMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.leftMirrored)
            break
        case UIImage.Orientation.downMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.rightMirrored)
            break
        case UIImage.Orientation.leftMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.downMirrored)
            break
        case UIImage.Orientation.rightMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.upMirrored)
            break
        default:
            break
        }
        return ret
    }
    
    func rotate90CounterClockwise() -> UIImage? {
        var ret: UIImage? = nil
        switch (self.imageOrientation) {
        case UIImage.Orientation.up:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.left)
            break
        case UIImage.Orientation.down:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.right)
            break
        case UIImage.Orientation.left:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.down)
            break
        case UIImage.Orientation.right:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.up)
            break
        case UIImage.Orientation.upMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.rightMirrored)
            break
        case UIImage.Orientation.downMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.leftMirrored)
            break
        case UIImage.Orientation.leftMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.upMirrored)
            break
        case UIImage.Orientation.rightMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.downMirrored)
            break
        default:
            break
        }
        return ret
    }
    
    func rotate180() -> UIImage? {
        var ret: UIImage? = nil
        switch (self.imageOrientation) {
        case UIImage.Orientation.up:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.down)
            break
        case UIImage.Orientation.down:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.up)
            break
        case UIImage.Orientation.left:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.right)
            break
        case UIImage.Orientation.right:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.left)
            break
        case UIImage.Orientation.upMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.downMirrored)
            break
        case UIImage.Orientation.downMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.upMirrored)
            break
        case UIImage.Orientation.leftMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.rightMirrored)
            break
        case UIImage.Orientation.rightMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.leftMirrored)
            break
        default:
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
        case UIImage.Orientation.up:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.upMirrored)
            break
        case UIImage.Orientation.down:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.downMirrored)
            break
        case UIImage.Orientation.left:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.rightMirrored)
            break
        case UIImage.Orientation.right:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.leftMirrored)
            break
        case UIImage.Orientation.upMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.up)
            break
        case UIImage.Orientation.downMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.down)
            break
        case UIImage.Orientation.leftMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.right)
            break
        case UIImage.Orientation.rightMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.left)
            break
        default:
            break
        }
        return ret
    }
    
    func flipVertical() -> UIImage? {
        var ret: UIImage? = nil
        switch (self.imageOrientation) {
        case UIImage.Orientation.up:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.downMirrored)
            break
        case UIImage.Orientation.down:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.upMirrored)
            break
        case UIImage.Orientation.left:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.leftMirrored)
            break
        case UIImage.Orientation.right:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.rightMirrored)
            break
        case UIImage.Orientation.upMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.down)
            break
        case UIImage.Orientation.downMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.up)
            break
        case UIImage.Orientation.leftMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.left)
            break
        case UIImage.Orientation.rightMirrored:
            ret = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: UIImage.Orientation.right)
            break
        default:
            break
        }
        return ret
    }
    
    func flipAll() -> UIImage? {
        return rotate180()
    }
    
}
