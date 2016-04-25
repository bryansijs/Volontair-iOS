//
//  CategoryIconModel.swift
//  Volontair
//
//  Created by M Mommersteeg on 25/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation

class CategoryIconModel {
    let category: String
    let iconUrl: String
    
    init(category: String, iconUrl: String) {
        self.category = category
        self.iconUrl = iconUrl
    }
}
