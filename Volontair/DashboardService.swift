//
//  DashboardService.swift
//  Volontair
//
//  Created by Bryan Sijs on 13-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire

class DashboardService {
    
    private var dashboardmodel: DashboardModel?
    
    func getDashboardModel() -> DashboardModel?{
        return dashboardmodel
    }
    
    func loadDashboardDataFromServer(completionHandler:() -> Void){
        let dashboardURL = ApiConfig.baseUrl + ApiConfig.dashboardUrl
        guard let dashURL = NSURL(string: dashboardURL) else {
            print("Error: cannot create URL")
            return
        }
        
        
        let dashboardParams : [String:Double] = [
        "radius": Double(getSavedRadius()),
        "latitude": (ServiceFactory.sharedInstance.userService.getCurrentUser()?.latitude)!,
        "longitude": (ServiceFactory.sharedInstance.userService.getCurrentUser()?.longitude)!
        ]
        
        Alamofire.request(.GET, dashURL, headers: ApiConfig.headers, parameters: dashboardParams)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    
                    self.dashboardmodel = DashboardModel(jsonData: JSON)
                    NSNotificationCenter.defaultCenter().postNotificationName(ApiConfig.dashboardNotificationKey, object: self.dashboardmodel)
                    completionHandler()
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }

    }
    
    private func getSavedRadius() -> Int{
        let radius = NSUserDefaults.standardUserDefaults().integerForKey(SettingsConstants.radiusKey)
        if radius != 0 {
            return radius
        } else {
            return 10
        }
    }
}