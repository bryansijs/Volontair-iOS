//
//  MapService.swift
//  Volontair
//
//  Created by M Mommersteeg on 10/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire

class MapService {
    
    static let sharedInstance = MapService()
    
    private var mapViewModel: MapViewModel?
    
    init() {
        self.mapViewModel = MapViewModel()
    }
    
    func getMapViewModel() -> MapViewModel? {
        return self.mapViewModel
    }
    
    func getRequests() {
        let requestsUrl = Config.url + Config.requestsEndPoint
        
        Alamofire.request(.GET, requestsUrl).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    for request in value["data"] as! [[String:AnyObject]] {
                        self.mapViewModel?.requests!.append(RequestModel(jsonData: request))
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        Config.requestsUpdatedNotificationKey,
                        object: self.mapViewModel?.requests)
                }
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func getOffers() {
        let offersUrl = Config.url + Config.offersEndPoint
        
        Alamofire.request(.GET, offersUrl).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    for offer in value["data"] as! [[String:AnyObject]] {
                        self.mapViewModel?.offers!.append(OfferModel(jsonData: offer))
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        Config.offersUpdatedNotificationKey,
                        object: self.mapViewModel?.offers)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}
