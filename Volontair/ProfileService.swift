//
//  ProfileService.swift
//  Volontair
//
//  Created by Bryan Sijs on 13-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire


class ProfileService  {
    
    private var profileModel : UserModel?  = nil
    
    private let userService = ServiceFactory.sharedInstance.userService
    
    func getUserProfileModel() -> UserModel?{
        return profileModel
    }
    
    init() {
        loadProfileFromServer()
    }
    
    func saveEditedProfile(){
        
        let currentUser = userService.getCurrentUser()!
        let parameters : [String:AnyObject] = [
            "name" :"\(currentUser.name)",
            "summary": "\(currentUser.summary)",
            "longitude": "\(currentUser.longitude)",
            "latitude" : "\(currentUser.latitude)"
        ]
        Alamofire.request(.PATCH, currentUser.userLink, headers: ApiConfig.headers, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response.result)
        }

    }
    
    func loadProfileFromServer(){
        print("loadProfileFromServer")
        if let userid = userService.getCurrentUser()?.userId {
            userService.loadUserDataFromServer(userid){(responseObject:UserModel?, error:NSError?) in
                if ((error) != nil) {
                    print(error)
                } else {
                    if let userModel = responseObject{
                        self.profileModel = userModel
                    }
                }
                
            }
        } else {
            print("error loading current user")
        }
    }
}