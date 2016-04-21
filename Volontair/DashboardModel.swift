//
//  DashboardModel.swift
//  Volontair
//
//  Created by Bryan Sijs on 09-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import SwiftyJSON

class DashboardModel {
    
    var nearbyVolonteers : Int
    var potentialContacts: Int
    var messages: [JSON]
    var connections: [JSON]
    
    init(jsonData: AnyObject){
        let json = JSON(jsonData)
        self.nearbyVolonteers = json["nearbyVolonteers"].intValue
        self.potentialContacts = json["potentialContacts"].intValue
        self.messages = json["messages"].arrayValue
        self.connections = json["connections"].arrayValue
    }
}