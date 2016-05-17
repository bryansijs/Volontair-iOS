//
//  RequestModel.swift
//  Volontair
//
//  Created by M Mommersteeg on 10/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class RequestModel : MapMarkerModel {
    
    var owner : UserModel?
    
    init(requestData: AnyObject, requestOwner: AnyObject, requestCategorys: [CategoryModel]) {
        let request = JSON(requestData)
        
        self.owner = UserModel(jsonData: requestOwner)
        
        let coordinate = CLLocationCoordinate2D(latitude: self.owner!.latitude, longitude: self.owner!.longitude)
        
        super.init(title: request["title"].stringValue,
                   summary: request["description"].stringValue,
                   coordinate: coordinate,
                   created: request["created"].stringValue,
                   updated: request["updated"].stringValue,
                   categorys: requestCategorys
        )
        
        
    }
}
