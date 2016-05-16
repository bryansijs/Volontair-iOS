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
    
    var username : String
    var name: String
    var profilePicture: NSData
    var summary: String
    var offersCategories: [String: JSON]
    var contacts: [JSON]
    var offers: [JSON]
    var requests: [RequestModel]
    var enabled: Bool
    var requestsLink : String
    var listenerConversationsLink: String
    var categoriesLink: String
    var latitude : String
    var longitude : String
    
    init(jsonData: AnyObject){
        let json = JSON(jsonData)
        self.username = json["username"].stringValue
        self.name = json["name"].stringValue
        self.summary = json["summary"].stringValue
        self.offersCategories = json["offersCategories"].dictionaryValue
        self.contacts = json["contacts"].arrayValue
        self.offers = json["offers"].arrayValue
        self.requests = [RequestModel]()
        
        if let items = json["requests"].arrayObject {
            for item in items {
                self.requests.append(RequestModel(jsonData: item))
            }
        }
        
        self.profilePicture = NSData()
        self.enabled = json["enabled"].boolValue
        self.requestsLink = json["_link"]["requests"].stringValue
        self.listenerConversationsLink = json["_link"]["conversations"].stringValue
        self.categoriesLink = json["_link"]["categories"].stringValue
        self.latitude = json["latitude"].stringValue
        self.longitude = json["longitude"].stringValue
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            //Download profile picutre async
            //let imageURL = "http://volontairtest-mikero.rhcloud.com/" + json["avatar"].string!
            //let url = NSURL(string: imageURL)
            //self.profilePicture = NSData(contentsOfURL: url!)!
        }
    }
}