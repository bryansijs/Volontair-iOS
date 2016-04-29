//
//  RequestService.swift
//  Volontair
//
//  Created by Bryan Sijs on 26-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire

class RequestService{
    
    var requests = [RequestModel]()
    
    //POST
    func submitRequest(request: RequestModel){
        
        //sample params.
        let parameters = [
            "foo": [1,2,3],
            "bar": [
                "baz": "qux"
            ]
        ]
        
        Alamofire.request(.POST, Config.url + Config.requestsPOSTPoint, parameters: parameters, encoding: .JSON).response { request, response, data, error in
            print(request)
            print(response)
            print(data)
            print(error)
        }
    }
    
    //GET
    func loadRequestDataFromServer(completionHandler: ([RequestModel]?,NSError?) -> Void) {
        Alamofire.request(.GET, Config.url + Config.requestsEndPoint).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    
                    for request in value["data"] as! [[String:AnyObject]] {
                        self.requests.append(RequestModel(jsonData: request))
                    }
                    completionHandler(self.requests, nil)
                }
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}