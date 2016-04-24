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
    
    func loadDashboardDataFromServer(){
        let dashboardURL = Config.url + Config.dashboardUrl
        guard let dashURL = NSURL(string: dashboardURL) else {
            print("Error: cannot create URL")
            return
        }
        
        Alamofire.request(.GET, dashURL).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.dashboardmodel = DashboardModel(jsonData: value)
                    NSNotificationCenter.defaultCenter().postNotificationName(Config.dashboardNotificationKey, object: self.dashboardmodel)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}