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
    
    let dashboardService = DahboardService()
    
    private init(){
        print("init DashboardServiceFactory")
    }
    
    func getDashboardService() -> DahboardService{
        return dashboardService
    }
}