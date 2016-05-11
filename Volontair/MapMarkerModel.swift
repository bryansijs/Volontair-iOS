//
//  MapMarkerModel.swift
//  Volontair
//
//  Created by M Mommersteeg on 15/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation
import MapKit

class MapMarkerModel: NSObject, MKAnnotation {
    
    let title: String?
    let category: String
    let summary: String
    let coordinate: CLLocationCoordinate2D
    let created: String
    let updated: String
    let iconKey: String
    
    init(jsonData: AnyObject){
        let json = JSON(jsonData)
        
        // Initialize model with JSON data here
        title = json["title"].stringValue
        category = json["category"].stringValue
        summary = json["summary"].stringValue
        iconKey = json["iconKey"].stringValue
        
        let lat = json["location"]["lat"].doubleValue
        let lon = json["location"]["lng"].doubleValue
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        created = json["created"].stringValue
        updated = json["updated"].stringValue
    }
    
    init(title: String?, category: String, summary: String, coordinate:CLLocationCoordinate2D, created: String, updated:String, iconKey:String){
        self.title = title
        self.category = category
        self.summary = summary
        self.coordinate = coordinate
        self.created = created
        self.updated = updated
        self.iconKey = iconKey
    }
}