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
    
        
    init(requestData: AnyObject, requestOwner: UserModel, requestCategorys: [CategoryModel]?) {
        let request = JSON(requestData)
        
        self.owner = requestOwner
        
        let coordinate = CLLocationCoordinate2D(latitude: self.owner!.latitude, longitude: self.owner!.longitude)
        
        super.init(title: request["title"].stringValue,
                   summary: request["description"].stringValue,
                   coordinate: coordinate,
                   closed: request["closed"].bool,
                   created: request["created"].stringValue,
                   updated: request["updated"].stringValue,
                   categorys: requestCategorys
        )
    }
    
    init(title: String, summary: String, closed: Bool, created: String, updated: String, category: CategoryModel, owner:UserModel){
        
        self.owner = owner
        let coordinate = CLLocationCoordinate2D(latitude: owner.latitude, longitude: owner.longitude)
        
        super.init(
            title: title,
            summary: summary,
            coordinate: coordinate,
            closed: closed,
            created: created,
            updated: updated,
            categorys: [category]
        )
    }
}
