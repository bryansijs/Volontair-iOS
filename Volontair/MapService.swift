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
    
    var requests: [RequestModel] {
        set {
            getRequests()
        }
        get {
            return self.requests
        }
    }
    var offers: [OfferModel] {
        set {
            getOffers()
        }
        get {
            return self.offers
        }
    }
    
    private init() {
        
    }
    
    func getRequests(){
        let requestsUrl = Config.url + Config.requestsEndPoint
        guard let url = NSURL(string: requestsUrl) else {
            print("Invalid url")
            return
        }
        
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.requests = []
                    for  request in response.result.value as! [Dictionary<String, AnyObject>] {
                        self.requests.append(RequestModel(jsonData: request))
                    }
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
                if let value = response.result.value {
                    self.offers = []
                    for  offer in response.result.value as! [Dictionary<String, AnyObject>] {
                        self.offers.append(OfferModel(jsonData: offer))
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}
