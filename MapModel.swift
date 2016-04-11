//
//  MapModel.swift
//  Volontair
//
//  Created by M Mommersteeg on 10/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import MapKit
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
        title = json["title"].stringValue
        category = json["category"].stringValue
        summary = json["summary"].stringValue
        
        let lat = json["location"]["lat"].doubleValue
        let lon = json["location"]["lng"].doubleValue
        location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        created = json["created"].stringValue
        updated = json["updated"].stringValue
    }
}