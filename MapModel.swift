//
//  MapModel.swift
//  Volontair
//
//  Created by M Mommersteeg on 10/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import SwiftyJSON

class MapModel {

    var title : String
    var category: String
    var summary: String
    var location: CLLocationCoordinate2D
    var created: String
    var updated: String

    init(jsonData: AnyObject){
        let json = JSON(jsonData)
    
        // Initialize model with JSON data here
        title = json["title"].string!
        category = json["category"].string!
        summary = json["summary"].string!
        location = json["location"].CLLocationCoordinate2D!
        created = json["created"].string!
        updated = json["updated"].string!
    }
}