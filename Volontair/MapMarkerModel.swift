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
    
    var title: String?
    var summary: String
    var coordinate: CLLocationCoordinate2D
    var created: String?
    var closed: Bool?
    var updated: String?
    var categorys : [CategoryModel]?
    var image : UIImage?
    
    //init(title: String?, summary: String, coordinate:CLLocationCoordinate2D, created: String, updated:String, categorys: [CategoryModel]){

    init(title: String?, summary: String, coordinate:CLLocationCoordinate2D,closed: Bool?, created: String, updated:String, categorys: [CategoryModel]?){
        self.title = title
        self.summary = summary
        self.coordinate = coordinate
        self.categorys = categorys
        self.created = created
        self.updated = updated
    }
    
    init(title: String?, summary: String, coordinate:CLLocationCoordinate2D, categorys: [CategoryModel]?){
        self.title = title
        self.summary = summary
        self.coordinate = coordinate
        self.categorys = categorys
    }
}
