//
//  DashboardServiceFactory.swift
//  Volontair
//
//  Created by Bryan Sijs on 13-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation

class DashboardServiceFactory  {
    static let sharedInstance = DashboardServiceFactory()
    
    let dashboardService = DashboardService()
    
    private init(){
        print("init DashboardServiceFactory")
    }
    
    func getDashboardService() -> DashboardService{
        return dashboardService
    }
}