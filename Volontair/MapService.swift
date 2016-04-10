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
    
    var mapViewModel: MapViewModel? = nil
    
    private init() {
        self.mapViewModel = MapViewModel()
    }
    
    func getRequests() {
        let requestsUrl = Config.url + Config.requestsEndPoint
        guard let url = NSURL(string: requestsUrl) else {
            print("Invalid url")
            return
        }
        
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Requests:")
                if let value = response.result.value {
                    for request in value["data"] as! [[String:AnyObject]] {
                        self.mapViewModel?.requests!.append(RequestModel(jsonData: request))
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        Config.requestsUpdatedNotificationKey,
                        object: self.mapViewModel?.requests as? AnyObject)
                }
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func getOffers() {
        let offersUrl = Config.url + Config.offersEndPoint
        guard let url = NSURL(string: offersUrl) else {
            print("Invalid url")
            return
        }
        
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("Offers:")
                if let value = response.result.value {
                    for offer in value["data"] as! [[String:AnyObject]] {
                        self.mapViewModel?.offers!.append(OfferModel(jsonData: offer))
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        Config.offersUpdatedNotificationKey,
                        object: self.mapViewModel?.offers as? AnyObject)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}
