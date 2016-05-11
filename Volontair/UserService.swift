//
//  UserService.swift
//  Volontair
//
//  Created by Bryan Sijs on 09-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire

class UserService  {
    
    var userModel : UserModel?
    let usersUrl = "/users/"
    
    func getUserProfileModel() -> UserModel?{
        return userModel
    }
    
    func loadUserDataFromServer(userId: Int){
        
        //check if URL is valid
        let profileURL = NSURL(string: ApiConfig.baseUrl + ApiConfig.usersUrl + String(userId))
        
        Alamofire.request(.GET, profileURL!).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.userModel = UserModel(jsonData: value)
                    NSNotificationCenter.defaultCenter().postNotificationName(Config.profileNotificationKey, object: self.userModel)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func loadUserDataFromServer(userId: Int, completionHandler: (UserModel?,NSError?) -> Void) {
        //check if URL is valid
        let profileURL = NSURL(string: ApiConfig.baseUrl + ApiConfig.usersUrl + String(userId))
        
        Alamofire.request(.GET, profileURL!).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.userModel = UserModel(jsonData: value)
                    NSNotificationCenter.defaultCenter().postNotificationName(Config.profileNotificationKey, object: self.userModel)
                    completionHandler(self.userModel, nil)
                }
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}
