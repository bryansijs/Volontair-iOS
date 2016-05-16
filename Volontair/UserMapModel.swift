//
//  UserMapModel.swift
//  Volontair
//
//  Created by Gebruiker on 5/12/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class UserMapModel : MapMarkerModel {
    
    var owner : UserModel?
    
    init(user: UserModel){
        self.owner = user
        let coor = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
        let categorys : [CategoryModel] = []
        
        super.init(title: user.name, summary: user.summary, coordinate: coor, categorys: categorys)
        
        if let imageData = user.profilePicture {
            self.image = UIImage(data:imageData, scale:2.4)
        }
    }
}