//
//  SettingsService.swift
//  Volontair
//
//  Created by Gebruiker on 5/24/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire

class SettingsService {
    
    func updateCurrentUserLocation(latitude : Double, longitude : Double) {
        
        let user : UserModel = ServiceFactory.sharedInstance.userService.getCurrentUser()!
        user.latitude = latitude
        user.longitude = longitude
        
        Alamofire.request(.PATCH, user.userLink, headers: ApiConfig.headers, parameters: ["latitude" : latitude,"longitude" : longitude], encoding: .JSON)
            .responseJSON { response in
                print(response.result)
                ServiceFactory.sharedInstance.dashboardService.loadDashboardDataFromServer({ 
                    
                })
                
        }
        
    }
    
    func updateUserCategories(categories : [CategoryModel]) {
        
        
    }
}