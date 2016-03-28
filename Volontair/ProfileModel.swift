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
    var contacts: [String: JSON]
//    var offers: [String: JSON]
//    var requests: [String: JSON]
    
    init(jsonData: AnyObject){
        let json = JSON(jsonData)
        self.id = json["id"].int!
        self.name = json["name"].string!
        self.summary = json["summary"].string!
        self.offersCategories = json["offersCategories"].dictionary!
        self.contacts = json["contacts"].dictionaryValue
        
        //TODO: fix offers and requests
//        print("JSON: \(json)")
//        self.offers = json["offers"].dictionary!
//        self.requests = json["requests"].dictionary!

        //Download profile picutre
        let imageURL = "http://volontairtest-mikero.rhcloud.com/" + json["avatar"].string!
        let url = NSURL(string: imageURL)
        self.profilePicture = NSData(contentsOfURL: url!)!
    }
}