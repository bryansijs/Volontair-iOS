//
//  CustomColorExtension.swift
//  Volontair
//
//  Created by Bryan Sijs on 26-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}