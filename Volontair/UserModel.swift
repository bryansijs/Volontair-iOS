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
    var userLink : String
    
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
        
        self.userLink = json["_links"]["self"]["href"].stringValue
        let userIdString = userLink.regex("[0-9]*$")[0]
        self.userId = Int(userIdString)!
        
        self.imageLink = ApiConfig.baseUrl + ApiConfig.usersUrl + userIdString + "/avatar.png"
    }
    
//    init(username: String, name: String, summary: String, enabled: Bool, requestsLink: String, offersLink: String, listenerConversationsLink: String, categoriesLink: String, latitude: Double, longitude: Double, userId: Int, imageLink:String, userLink: String){
//        self.username = username
//        self.name = name
//        self.summary = summary
//        self.enabled = enabled
//        self.requestsLink = requestsLink
//        self.offersLink = offersLink
//        self.listenerConversationsLink = listenerConversationsLink
//        self.categoriesLink = categoriesLink
//        self.latitude = latitude
//        self.longitude = longitude
//        self.userId = userId
//        self.imageLink = imageLink
//        self.userLink = userLink
//    }
}