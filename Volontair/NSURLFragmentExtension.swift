//
//  NSURLFragmentExtension.swift
//  Volontair
//
//  Created by Gebruiker on 5/10/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation

extension NSURL {
    var fragments: [String: String] {
        var results = [String: String]()
        if let pairs = self.fragment?.componentsSeparatedByString("&") where pairs.count > 0 {
            for pair: String in pairs {
                if let keyValue = pair.componentsSeparatedByString("=") as [String]? {
                    results.updateValue(keyValue[1], forKey: keyValue[0])
                }
            }
        }
        return results
    }
}