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
    
    var userId: Int
    var username : String
    var name: String
    var profilePicture: NSData?
    var summary: String
    var enabled: Bool
    
    var categorys : [CategoryModel]?
    var offers : [OfferModel]?
    var requests : [RequestModel]?
    
    var requestsLink : String
    var offersLink : String
    var listenerConversationsLink: String
    var categoriesLink: String
    var imageLink : String
    
    var latitude : Double
    var longitude : Double
    
    init(jsonData: AnyObject){
        let json = JSON(jsonData)
        self.username = json["username"].stringValue
        self.name = json["name"].stringValue
        self.summary = json["summary"].stringValue
        self.enabled = json["enabled"].boolValue
        self.requestsLink = json["_links"]["requests"]["href"].stringValue
        self.offersLink = json["_links"]["offers"]["href"].stringValue
        self.listenerConversationsLink = json["_links"]["listenerConversations"]["href"].stringValue
        self.categoriesLink = json["_links"]["categories"]["href"].stringValue
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        
        let userIdString = json["_links"]["self"]["href"].stringValue.regex("[0-9]*$")[0]
        self.userId = Int(userIdString)!
        
        self.imageLink = ApiConfig.baseUrl + ApiConfig.usersUrl + userIdString + "/avatar.png"
    }
}