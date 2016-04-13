//
//  ProfileServiceFactory.swift
//  Volontair
//
//  Created by Bryan Sijs on 13-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation

class ProfileServiceFactory  {
    static let sharedInstance = ProfileServiceFactory()
    
    let profileService = ProfileService()
    
    private init(){
        print("init ProfileServiceFactory")
    }
    
    func getProfileService() -> ProfileService{
        return profileService
    }
}