//
//  UserService.swift
//  Volontair
//
//  Created by Bryan Sijs on 09-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

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
    
    func loadProfilePictures(users :[UserModel]? , completionHandler: ([UserModel]?, NSError?) ->Void) {
        print("loadProfilePictures")
        var count = 0;
        
        if users != nil {
            for user in users! {
                Alamofire.request(.GET, user.imageLink , headers: ApiConfig.headers, encoding: .JSON).response { (request, response, data, error) in
                    if let value = data {
                        user.profilePicture = NSData(data: value)
                    }
                    count = count + 1
                    
                    if (count == (users!.count)) {
                        completionHandler(users, nil)
                    }
                }
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
    
    internal func loadUserCategorys(user: UserModel){
        Alamofire.request(.GET, user.categoriesLink , headers: ApiConfig.headers, encoding: .JSON).validate().responseJSON { response in switch
            response.result {
                case .Success:
                    if let value = response.result.value {
                        var categorys : [CategoryModel] = []
                        
                        for cat in value["_embedded"]!!["categories"] as! [[String:AnyObject]]{
                            categorys.append(CategoryModel(JSONData: cat))
                        }
                        
                        
                    }
                case .Failure(let error):
                    print(error)
            }
        }
    }
    
    func loadUserRequests(user: UserModel){
        
        Alamofire.request(.GET, user.requestsLink, headers: ApiConfig.headers, encoding: .JSON).validate().responseJSON { response in switch
        response.result {
        case .Success:
            if let value = response.result.value {
                print(response.result)
                print(response.result.value)
                
                var requests : [RequestModel] = []
                
                for req in value["_embedded"]!!["requests"] as! [[String:AnyObject]]{
                    let request = RequestModel(requestData: req, requestOwner: user, requestCategorys: user.categorys)
                    let link = req["_links"]!["category"] as! [String:AnyObject]
                    ServiceFactory.sharedInstance.requestService.loadRequestCategory(request, requestURL: link["href"]! as! String)
                    requests.append(request)
                }
                user.requests = requests
            }
        case .Failure(let error):
            print(error)
            }
        }
    }
}
