//
//  MapServiceFactory.swift
//  Volontair
//
//  Created by M Mommersteeg on 15/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation

class MapServiceFactory {
    let mapService = MapService()
    
    private init() {
        print("Init MapServiceFactory")
    }
    
    func getMapService() -> MapService {
        return mapService
    }
}