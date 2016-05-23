//
//  ServiceFactory.swift
//  Volontair
//
//  Created by Bryan Sijs on 13-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire

class ServiceFactory  {
    static let sharedInstance = ServiceFactory()
    
    let userService = UserService()
    let requestService = RequestService()
    let offerService = OfferService()
    let categoryService = CategoryService()
    
    private init(){
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ApiConfig.headers
        print("init ServiceFactory")
    }
}
