//
//  WizardServiceFactory.swift
//  Volontair
//
//  Created by Bryan Sijs on 21-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation

class WizardServiceFactory  {
    static let sharedInstance = WizardServiceFactory()
    
    let wizardService = WizardService()
    
    private init(){
        print("init WizardServiceFactory")
    }
    
    func getWizardService() -> WizardService{
        return wizardService
    }
}