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
    
    func getUserProfileModel() -> UserModel?{
        return userModel
    }
    
    func loadUserDataFromServer(userId: Int){
        
        //check if URL is valid
        let profileURL = NSURL(string: Config.url + Config.profileUrl + String(userId))
        
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
        let profileURL = NSURL(string: Config.url + Config.profileUrl + String(userId))
        
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
    
    func loadUsersInNeighbourhood(completionHandler: ([UserModel]?, NSError?) ->Void) {
        let headers = [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer a3d457c2-39c5-44b2-9623-3cdabdb1bc4c"
        ]
        
        let usersUrl = NSURL(string: "http://192.168.178.49:6789/api/v1/users")
        
        Alamofire.request(.GET, usersUrl!, headers: headers, encoding: .JSON).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        
                        print("Success with JSON: \(value)")
                        
//                        self.userModel = UserModel(jsonData: value)
//                        NSNotificationCenter.defaultCenter().postNotificationName(Config.profileNotificationKey, object: self.userModel)
//                        completionHandler(self.userModel, nil)
                    }
                case .Failure(let error):
                    print(error)
                    //completionHandler(nil, error)
                }
        }

    }
}
