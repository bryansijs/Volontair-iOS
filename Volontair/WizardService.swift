//
//  WizardService.swift
//  Volontair
//
//  Created by Bryan Sijs on 21-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire

class WizardService {
    
    var volunteer = true
    var limited = true
    var categories : [CategoryModel]?
    var latitude : Double = 0
    var longtitude: Double = 0
    var radius = 0
    var description = "";

    
    func submitUser(){
        if let user = ServiceFactory.sharedInstance.userService.getCurrentUser(){
            setLocalUserProperties(user)
            saveUserOnServer(user)
        }
    }
    
    private func setLocalUserProperties(user: UserModel){
        if let user = ServiceFactory.sharedInstance.userService.getCurrentUser(){
            user.categorys = categories
            user.latitude = latitude
            user.longitude = longtitude
            user.summary = description
            
            NSUserDefaults.standardUserDefaults().setInteger(self.radius, forKey: SettingsConstants.radiusKey)
        }
        
    }
    private func saveUserOnServer(user: UserModel){
        let parameters : [String:AnyObject] = [
            "goal": getUserGoalString(),
            "latitude": latitude,
            "longitude": longtitude,
            "summary" : description
        ]
        print(parameters)
        print(ApiConfig.headers)
        Alamofire.request(.PATCH, user.userLink, headers: ApiConfig.headers, parameters: parameters, encoding: .JSON).response { request, response, data, error in
            print(error)
        }
        saveUserCategoryOnServer(user)
        
        
    }
    
    private func saveUserCategoryOnServer(user: UserModel){
        var categoryLinks = [String]()
        for category in self.categories!{
            categoryLinks.append(category.link!)
        }
        
        let parameters : [String:AnyObject] = [
            "": categoryLinks
        ]
        
        print(user.userLink + ApiConfig.categoryUrl)
        
        Alamofire.request(.POST, user.userLink + ApiConfig.categoryUrl, headers: ApiConfig.headers, parameters: parameters, encoding: .JSON).response { request, response, data, error in
            print(error)
        }

    }
    
    private func getUserGoalString() -> String{
        if(self.volunteer && self.limited){
            return "GIVE_AND_GET_HELP"
        }
        if(self.volunteer){
            return "GIVE_HELP"
        }
        else{
            return "GET_HELP"
        }
    }
    
    func setUserTypeProperties(volunteer:Bool, limited: Bool){
        self.volunteer = volunteer
        self.limited = limited
    }
    
    func setUserCategories(categories:[CategoryModel]){
        self.categories = categories
    }
    
    func setUserLocationProperties(latitude: Double, longtitude: Double, radius: Int, description: String){
        self.latitude = latitude
        self.longtitude = longtitude
        self.radius = radius
        self.description = description
    }
}