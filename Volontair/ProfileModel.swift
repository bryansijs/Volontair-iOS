//
//  ProfileModel.swift
//  Volontair
//
//  Created by Bryan Sijs on 21-03-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProfileModel {
    
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
        self.id = json["id"].int!
        self.name = json["name"].string!
        self.summary = json["summary"].stringValue
        self.offersCategories = json["offersCategories"].dictionaryValue
        self.contacts = json["contacts"].arrayValue
        self.offers = json["offers"].arrayValue
        self.requests = json["requests"].arrayValue

        //Download profile picutre
        let imageURL = "http://volontairtest-mikero.rhcloud.com/" + json["avatar"].string!
        let url = NSURL(string: imageURL)
        self.profilePicture = NSData(contentsOfURL: url!)!
    }
}