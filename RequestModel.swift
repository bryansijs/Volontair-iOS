//
//  RequestModel.swift
//  Volontair
//
//  Created by M Mommersteeg on 10/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import CoreLocation

class RequestModel : MapMarkerModel {
    
    override init(jsonData: AnyObject) {
        print(jsonData)
        super.init(jsonData: jsonData)
    }
    
    override init(title: String?, category: String, summary: String, coordinate: CLLocationCoordinate2D, created: String, updated: String, iconKey: String){
        super.init(title: title, category: category, summary: summary, coordinate: coordinate, created: created, updated: updated, iconKey: iconKey)
    }
}
