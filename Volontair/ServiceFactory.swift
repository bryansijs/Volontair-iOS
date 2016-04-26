//
//  ServiceFactory.swift
//  Volontair
//
//  Created by Bryan Sijs on 13-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation

class ServiceFactory  {
    static let sharedInstance = ServiceFactory()
    
    let userService = UserService()
    let requestService = RequestService()
    
    private init(){
        print("init ServiceFactory")
    }
    
    func getUserService() -> UserService{
        return userService
    }
}
