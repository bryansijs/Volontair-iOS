//
//  ProfileService.swift
//  Volontair
//
//  Created by Bryan Sijs on 13-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation


class ProfileService  {
    
    private var profileModel : UserModel?  = nil
    
    private let userService = ServiceFactory.sharedInstance.getUserService()
    
    func getUserProfileModel() -> UserModel?{
        return profileModel
    }
    
    init() {
        loadProfileFromServer()
    }
    
    //TODO: get current userID
    func loadProfileFromServer(){
        userService.loadUserDataFromServer(1){(responseObject:UserModel?, error:NSError?) in
            if ((error) != nil) {
                print(error)
            } else {
                if let userModel = responseObject{
                    self.profileModel = userModel
                }
            }

        }
    }
}