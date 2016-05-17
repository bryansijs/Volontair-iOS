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
import Alamofire

class MapMarkerModel: NSObject, MKAnnotation {
    
    let title: String?
    let summary: String
    var coordinate: CLLocationCoordinate2D
    var created: String?
    var updated: String?
    var categorys : [CategoryModel]?
    var image : UIImage?
    
//    init(jsonData: AnyObject){
//        let json = JSON(jsonData)
//        
//        // Initialize model with JSON data here
//        title = json["title"].stringValue
//        category = json["category"].stringValue
//        summary = json["description"].stringValue
//        
//        let lat = json["latitude"].doubleValue
//        let lon = json["longitude"].doubleValue
////        closed = json["closed"].boolValue
//        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//        
//        created = json["created"].stringValue
//        updated = json["updated"].string
//    }
    
    init(title: String?, summary: String, coordinate:CLLocationCoordinate2D, created: String, updated:String, categorys: [CategoryModel]){
        self.title = title
        self.summary = summary
        self.coordinate = coordinate
        self.categorys = categorys
        self.created = created
        self.updated = updated
    }
    

    init(title: String?, summary: String, coordinate:CLLocationCoordinate2D, categorys: [CategoryModel]){
        self.title = title
        self.summary = summary
        self.coordinate = coordinate
        self.categorys = categorys
    }
    
//    init(title: String?, category: String, summary: String, coordinate:CLLocationCoordinate2D){
//        self.title = title
//        self.category = category
//        self.summary = summary
//        self.coordinate = coordinate
//    }
}
