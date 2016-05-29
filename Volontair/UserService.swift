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
    

    func saveUserCategoryOnServer(){
        let defaultContentType = ApiConfig.headers["Content-Type"]
        ApiConfig.headers["Content-Type"] = "text/uri-list"
        for category in (self.userMe?.categorys!)!{
            
            Alamofire.Manager.request(.POST, (self.userMe?.userLink)! + ApiConfig.categoryUrl, bodyObject: category.link!,headers: ApiConfig.headers)
                .responseJSON { response in
                    print(response.result)
            }
        }
        ApiConfig.headers["Content-Type"] = defaultContentType
    }
    
    func deleteUserCategoryServer(category: CategoryModel) {
//        let defaultContentType = ApiConfig.headers["Content-Type"]
//        ApiConfig.headers["Content-Type"] = "text/uri-list"
        let url = NSURL(string: (self.userMe?.userLink)! + ApiConfig.categoryUrl + "/" + category.id!)
        
        Alamofire.request(.DELETE, url!, headers: ApiConfig.headers)
            .responseJSON { response in
                print(response.result)
        }
//            Alamofire.Manager.request(.GET, (self.userMe?.userLink)! + ApiConfig.categoryUrl + "/" + category.id!,headers: ApiConfig.headers)
//                .responseJSON { response in
//                    print(response.result)
//            }
 //       ApiConfig.headers["Content-Type"] = defaultContentType
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
        
        let parameters : [String : String] = [
        "width" : "500",
        "height" : "500"
        ]
        
        
        if users != nil {
            for user in users! {
                Alamofire.request(.GET, user.imageLink + "?width=180&height=180", encoding: .JSON).response { (request, response, data, error) in
                    print(request)
                    print(response)
                    print(user.imageLink)
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
                            
                            let user = UserModel(jsonData: user)
                            usersData?.append(user)
                            self.loadUserCategorys(user)
                            
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
                        user.categorys = categorys
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
