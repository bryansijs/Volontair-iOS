//
//  RBResizer.swift
//  Volontair
//
//  Created by Bryan Sijs on 17-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

func RBSquareImageTo(image: UIImage, size: CGSize) -> UIImage {
    return RBResizeImage(RBSquareImage(image), targetSize: size)
}

func RBSquareImage(image: UIImage) -> UIImage {
    let originalWidth  = CGFloat(ApiConfig.mapIconDiameter)
    let originalHeight = CGFloat(ApiConfig.mapIconDiameter)
    
    var edge: CGFloat
    if originalWidth > originalHeight {
        edge = originalHeight
    } else {
        edge = originalWidth
    }
    
    let posX = (originalWidth  - edge) / 2.0
    let posY = (originalHeight - edge) / 2.0
    
    let cropSquare = CGRectMake(posX, posY, edge, edge)
    
    let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
    return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
}

func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
    } else {
        newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRectMake(0, 0, newSize.width, newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.drawInRect(rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}

func getRoundedImage(image : UIImage) -> UIImage {
    let imageLayer = CALayer()
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height)
    imageLayer.contents = image.CGImage
    
    imageLayer.masksToBounds = true
    imageLayer.cornerRadius = image.size.width/2
    
    UIGraphicsBeginImageContext(image.size)
    
    imageLayer.renderInContext(UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return RBResizeImage(roundedImage, targetSize: CGSize(width: 50, height: 50))
}