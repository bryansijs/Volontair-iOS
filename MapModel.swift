//
//  MapModel.swift
//  Volontair
//
//  Created by M Mommersteeg on 04/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation

class MapModel {
    
    var title : String
    var category: String
    var summary: String
    var latitude: Double
    var longitude: Double
    var created: NSDate
    var updated: NSDate
    
    init(jsonData: AnyObject){
        //let json = JSON(jsonData)
        
        // Initialize model with JSON data here
        title = ""
        category = ""
        summary = ""
        latitude = 0.0
        longitude = 0.0
        created = NSDate()
        updated = NSDate()
    }
}
