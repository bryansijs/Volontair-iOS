//
//  OfferService.swift
//  Volontair
//
//  Created by Bryan Sijs on 26-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire

class OfferService{
    
    var offers = [OfferModel]()
    
    //POST
    func submitOffer(request: OfferModel){
        
        //sample params.
        let parameters = [
            "foo": [1,2,3],
            "bar": [
                "baz": "qux"
            ]
        ]
        
        Alamofire.request(.POST, Config.url + Config.offersPOSTPoint, parameters: parameters, encoding: .JSON).response { request, response, data, error in
            print(request)
            print(response)
            print(data)
            print(error)
        }
    }
    
    //GET
    func loadOffersDataFromServer(completionHandler: ([OfferModel]?,NSError?) -> Void) {
        Alamofire.request(.GET, Config.url + Config.offersEndPoint).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    
                    for offer in value["data"] as! [[String:AnyObject]] {
                        self.offers.append(OfferModel(jsonData: offer))
                    }
                    completionHandler(self.offers, nil)
                }
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}