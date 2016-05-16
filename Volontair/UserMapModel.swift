//
//  UserMapModel.swift
//  Volontair
//
//  Created by Gebruiker on 5/12/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import CoreLocation

class UserMapModel : MapMarkerModel {
    
    override init(jsonData: AnyObject) {
        super.init(jsonData: jsonData)
    }
    
    override init(title: String?, category: String, summary: String, coordinate: CLLocationCoordinate2D, created: String, updated: String , iconKey: String){
        super.init(title: title, category: category, summary: summary, coordinate: coordinate, created: created, updated: updated, iconKey: iconKey)
    }
}