//
//  WizardService.swift
//  Volontair
//
//  Created by Bryan Sijs on 21-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation

class WizardService {
    
    var volunteer = true
    var limited = true
    var categories : [CategoryModel]?
    var latitude : Double = 0
    var longtitude: Double = 0
    var radius = 0
    var description = "";

    
    func submitUser(){
        //TODO: submit User propertys to server
    }
    
    func setUserTypeProperties(volunteer:Bool, limited: Bool){
        self.volunteer = volunteer
        self.limited = limited
    }
    
    func setUserCategories(categories:[CategoryModel]){
        self.categories = categories
    }
    
    func setUserLocationProperties(latitude: Double, longtitude: Double, radius: Int, description: String){
        self.latitude = latitude
        self.longtitude = longtitude
        self.radius = radius
        self.description = description
    }
}