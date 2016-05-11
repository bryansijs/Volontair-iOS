//
//  UserModel.swift
//  Volontair
//
//  Created by Bryan Sijs on 13-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class UserModel {
    
    var id : Int
    var name: String
    var profilePicture: NSData
    var summary: String
    var offersCategories: [String: JSON]
    var contacts: [JSON]
    var offers: [JSON]
    var requests: [JSON]
    
    
    init(jsonData: AnyObject){
        let json = JSON(jsonData)
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.summary = json["summary"].stringValue
        self.offersCategories = json["offersCategories"].dictionaryValue
        self.contacts = json["contacts"].arrayValue
        self.offers = json["offers"].arrayValue
        self.requests = json["requests"].arrayValue
        self.profilePicture = NSData()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            //Download profile picutre async
            //let imageURL = "http://volontairtest-mikero.rhcloud.com/" + json["avatar"].string!
            //let url = NSURL(string: imageURL)
            //self.profilePicture = NSData(contentsOfURL: url!)!
        }
    }
}