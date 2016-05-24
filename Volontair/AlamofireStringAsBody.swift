//
//  AlamofireStringAsBody.swift
//  Volontair
//
//  Created by Bryan Sijs on 23-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire

extension Alamofire.Manager {
    public class func request(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
          bodyObject: String,
          headers: [String : String] )
        -> Request
    {
        return Manager.sharedInstance.request(
            method,
            URLString,
            parameters: [:],
            headers: headers,
            encoding: .Custom({ (convertible, params) in
                let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
                mutableRequest.HTTPBody = bodyObject.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                return (mutableRequest, nil)
            })
        )
    }
}