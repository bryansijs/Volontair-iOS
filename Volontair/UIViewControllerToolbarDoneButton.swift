//
//  UIViewControllerToolbarDoneButton.swift
//  Volontair
//
//  Created by Bryan Sijs on 25-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

extension UIViewController {
    func doneToolbar (selector :Selector) -> UIToolbar {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = .Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: selector)
        
        var items: [UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        return doneToolbar
    }
}