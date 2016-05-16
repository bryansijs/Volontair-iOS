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
    var userMe : UserModel?
    
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
    
    func setCurrentUser(user: UserModel) {
        self.userMe = user
    }
    
    func getCurrentUser() -> UserModel? {
        return self.userMe
    }
    
    func loadUserDataFromServer(userId: Int, completionHandler: (UserModel?,NSError?) -> Void) {
        
        //check if URL is valid
        let profileURL = NSURL(string: ApiConfig.baseUrl + ApiConfig.usersUrl + String(userId))
        
        Alamofire.request(.GET, profileURL!, headers: ApiConfig.headers).validate().responseJSON { response in
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
    
        Alamofire.request(.GET, ApiConfig.baseUrl + ApiConfig.usersUrl , headers: ApiConfig.headers, encoding: .JSON).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        var usersData : [UserModel]? = []
                        
                        for user in value["_embedded"]!!["users"] as! [[String:AnyObject]] {
                            print(user)
                            usersData?.append(UserModel(jsonData: user))
                            //self.requests.append(RequestModel(jsonData: request))
                        }
                        
                        completionHandler(usersData, nil)
                    }
                case .Failure(let error):
                    print(error)
                    completionHandler(nil, error)
                }
        }

    }
}
