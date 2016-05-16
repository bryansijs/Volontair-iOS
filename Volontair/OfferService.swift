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
        
        Alamofire.request(.POST, ApiConfig.baseUrl + ApiConfig.offersEndPoint, headers: ApiConfig.headers, parameters: parameters, encoding: .JSON).response { request, response, data, error in
            print(request)
            print(response)
            print(data)
            print(error)
        }
    }
    
    //GET
    func loadOffersDataFromServer(completionHandler: ([OfferModel]?,NSError?) -> Void) {
        
        //check if URL is valid
        let offersUrl = NSURL(string: ApiConfig.baseUrl + ApiConfig.offersEndPoint)
        
        Alamofire.request(.GET, offersUrl!, headers: ApiConfig.headers).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    for offer in value["_embedded"]!!["offers"] as! [[String:AnyObject]] {
                        print(offer)
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