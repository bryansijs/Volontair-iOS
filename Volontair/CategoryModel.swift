//
//  CategoryModel.swift
//  Volontair
//
//  Created by Bryan Sijs on 20-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import SwiftyJSON

class CategoryModel {
    
    var created : String?
    var updated: String?
    var name: String
    var iconKey: String
    var colorHex: String

    init(JSONData: AnyObject) {
        let data = JSON(JSONData)
        self.created = data["created"].stringValue
        self.updated = data["updated"].stringValue
        self.name = data["name"].stringValue
        self.iconKey = data["iconKey"].stringValue
        self.colorHex = data["colorHex"].stringValue
    }
    
    init(name:String,iconName: String, iconColorHex: String){
        self.name = name
        self.iconKey = iconName
        self.colorHex = iconColorHex
    }
}