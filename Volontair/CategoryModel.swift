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
    
    var name: String
    var iconName: String
    
    init(JSONData: AnyObject) {
        let data = JSON(JSONData)
        self.name = data["name"].stringValue
        self.iconName = data["iconKey"].stringValue
    }
    
    init(name:String,iconName: String){
        self.name = name
        self.iconName = iconName
    }
}