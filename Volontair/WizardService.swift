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
    var description = "";

    
    func submitUser(){
        if let user = ServiceFactory.sharedInstance.userService.getCurrentUser(){
            setLocalUserProperties(user)
            saveUserOnServer(user)
        }
    }
    
    private func setLocalUserProperties(user: UserModel){
        if let user = ServiceFactory.sharedInstance.userService.getCurrentUser(){
            user.categorys = self.categories
            user.latitude = self.latitude
            user.longitude = self.longtitude
            user.summary = self.description
        }
        
    }
    private func saveUserOnServer(user: UserModel){
        let parameters : [String:AnyObject] = [
            "goal": "\(getUserGoalString())",
            "latitude": "\(self.latitude)",
            "longitude": "\(self.longtitude)",
            "summary" : "\(self.description)"
        ]
        Alamofire.request(.PATCH, user.userLink, headers: ApiConfig.headers, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
        }
        saveUserCategoryOnServer(user)
    }
    
    private func saveUserCategoryOnServer(user: UserModel){

        let defaultContentType = ApiConfig.headers["Content-Type"]
        ApiConfig.headers["Content-Type"] = "text/uri-list"
        for category in self.categories!{

            Alamofire.Manager.request(.POST, user.userLink + ApiConfig.categoryUrl, bodyObject: category.link!,headers: ApiConfig.headers)
                .responseJSON { response in
                    print(response.result)
                    print(response.response)
                    print(response.request)
            }
        }
        ApiConfig.headers["Content-Type"] = defaultContentType
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
    
    func setUserLocationProperties(latitude: Double, longtitude: Double, description: String){
        self.latitude = latitude
        self.longtitude = longtitude
        self.description = description
    }
}