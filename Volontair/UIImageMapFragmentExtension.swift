//
//  UIImageMapFragmentExtension.swift
//  Volontair
//
//  Created by Gebruiker on 5/24/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

extension UIImage {
    func markerCircle (backgroundColor : UIColor) -> UIImage? {
        let square = CGSize(width: ApiConfig.mapIconDiameter , height: ApiConfig.mapIconDiameter)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .Center
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2.0
        imageView.backgroundColor = backgroundColor
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}