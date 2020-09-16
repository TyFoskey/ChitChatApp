//
//  UIImage.swift
//  ChitChat
//
//  Created by ty foskey on 9/15/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

internal extension UIImage {
   
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resize(toSizeInPixel: CGSize) -> UIImage {
        let screenScale = UIScreen.main.scale
        let sizeInPoint = CGSize(width: toSizeInPixel.width / screenScale,
                                 height: toSizeInPixel.height / screenScale)
        return resize(toSizeInPoint: sizeInPoint)
    }
    
    func resize(toSizeInPoint: CGSize) -> UIImage {
        let size = self.size
        var newImage: UIImage
        
        let widthRatio  = toSizeInPoint.width  / size.width
        let heightRatio = toSizeInPoint.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
    
    /// Kudos to Trevor Harmon and his UIImage+Resize category from
    // which this code is heavily inspired.
    func resetOrientation() -> UIImage {
        // Image has no orientation, so keep the same
        if imageOrientation == .up {
            return self
        }
        
        // Process the transform corresponding to the current orientation
        var transform = CGAffineTransform.identity
        switch imageOrientation {
        case .down, .downMirrored:           // EXIF = 3, 4
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            
        case .left, .leftMirrored:           // EXIF = 6, 5
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            
        case .right, .rightMirrored:          // EXIF = 8, 7
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat((Double.pi / 2)))
        default:
            ()
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:     // EXIF = 2, 4
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:   //EXIF = 5, 7
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            ()
        }
        
        // Draw a new image with the calculated transform
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: cgImage!.bitsPerComponent,
                                bytesPerRow: 0,
                                space: cgImage!.colorSpace!,
                                bitmapInfo: cgImage!.bitmapInfo.rawValue)
        context?.concatenate(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        if let newImageRef =  context?.makeImage() {
            let newImage = UIImage(cgImage: newImageRef)
            return newImage
        }
        
        // In case things go wrong, still return self.
        return self
    }
    
    
    func resizedSameImageIfNeeded(height: CGFloat,
                                  width: CGFloat) -> UIImage {
        let size = sameSize(for: self.size, sameAtHeight: height, sameAtWidth: width)
        if let resizedImage = self.resized(to: size) {
            print("resizing")
            return resizedImage
        } else {
            return self
        }
    }
    
    fileprivate func sameSize(for size: CGSize, sameAtHeight: CGFloat, sameAtWidth: CGFloat) -> CGSize {
        var cappedWidth: CGFloat = 0
        var cappedHeight: CGFloat = 0
        
        if size.width > size.height {
            // Landscape
            let heightRatio = size.height / size.width
            cappedWidth = sameAtWidth
            cappedHeight = sameAtHeight//cappedWidth * heightRatio
        } else if size.height > size.width {
            // Portrait
            let widthRatio = size.width / size.height
            cappedHeight = sameAtHeight
            cappedWidth = sameAtWidth//cappedHeight * widthRatio
        } else {
            // Squared
            cappedWidth = sameAtWidth
            cappedHeight = sameAtHeight
        }
        return CGSize(width: cappedWidth, height: cappedHeight)
    }
    
    fileprivate func cappedSize(for size: CGSize, cappedAt: CGFloat) -> CGSize {
        var cappedWidth: CGFloat = 0
        var cappedHeight: CGFloat = 0
        if size.width > size.height {
            // Landscape
            let heightRatio = size.height / size.width
            cappedWidth = min(size.width, cappedAt)
            cappedHeight = cappedWidth * heightRatio
        } else if size.height > size.width {
            // Portrait
            let widthRatio = size.width / size.height
            cappedHeight = min(size.height, cappedAt)
            cappedWidth = cappedHeight * widthRatio
        } else {
            // Squared
            cappedWidth = min(size.width, cappedAt)
            cappedHeight = min(size.height, cappedAt)
        }
        return CGSize(width: cappedWidth, height: cappedHeight)
    }
    
    func toCIImage() -> CIImage? {
        return self.ciImage ?? CIImage(cgImage: self.cgImage!)
    }
    
    
}
