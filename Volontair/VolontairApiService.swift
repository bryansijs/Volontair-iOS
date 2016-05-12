//
//  VolontairApiService.swift
//  Volontair
//
//  Created by Gebruiker on 5/4/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class VolontairApiService {
    var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    let baseOnlineUrl = "http://volontair.herokuapp.com"
    let baseUrl = "http://192.168.178.49:6789"//"http://192.168.178.49:6789"
    let registerFacebookTokenUrl = "/auth/facebook/client?accessToken=";
    let getVolontairApiTokenUrl = "/oauth/authorize?response_type=token&client_id=volontair&redirect_uri=/";
    let getMeUrl = "/api/v1/users/me"
    //let tempvolontairToken = "fca4a7c6-23c0-4974-82e1-3d2e2e29c9d9"
    
    internal func login(facebookToken: String , completionHandler:()->Void ) {
        if let token = getVolontairApiToken() {
            self.checkApiAuthentication(token, completeSuccesHandler: completionHandler)
        } else {
            self.loginApi(facebookToken, completeSuccseHandler: completionHandler )
        }
    }
    
    internal func login(completeSuccesHandler:()->Void, completeErrorHandler:()->Void ) {
        if let token = getVolontairApiToken() {
            self.checkApiAuthentication(token, completeSuccesHandler: completeSuccesHandler)
        } else {
            if self.getFacebookToken() != "" {
                self.loginApi(self.getFacebookToken()!, completeSuccseHandler: completeSuccesHandler)
            } else {
                completeErrorHandler()
            }
        }
    }
    
    private func checkApiAuthentication(volontairToken : String, completeSuccesHandler:()->Void? ) {
        let headers = [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(volontairToken)"
        ]
        
        Alamofire.request(.GET, self.baseUrl + self.getMeUrl, headers: headers, encoding: .JSON)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    
                    if let name = JSON["name"] {
                        print("Jep data is legetiem \(name)")
                        self.setGlobalHeaders(headers)
                        self.setVolontairApiToken(volontairToken)
                        completeSuccesHandler()
                    } else {
                        
                        print("shit dit go wrong")
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    
    private func loginApi(facebookToken : String, completeSuccseHandler:()->Void?) {
        let headers = [ "Content-Type" : "application/json" ]
        
        Alamofire.request(.GET, self.baseUrl + self.registerFacebookTokenUrl + facebookToken , headers: headers)
            .responseData { response in
                
                Alamofire.request(.GET, self.baseUrl + self.getVolontairApiTokenUrl, headers: headers, encoding: .JSON)
                    .responseString() { response in
                        
                        print(response.response)
                        print(response.result)
                        
                        let URL = response.response?.URL?.fragments //In extension/NSURLFragmentExtension
                        
                        if URL?.count > 0 {
                            self.checkApiAuthentication(URL!["access_token"]!, completeSuccesHandler: completeSuccseHandler);
                        } else {
                            //Facebook token is wrong
                        }
                }
        }
    }
    
    private func setGlobalHeaders(headers : [NSObject: AnyObject]) {
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers
    }
    
    // Getters en Setters
    internal func getVolontairApiToken() -> String? {
        if let token = prefs.stringForKey("VolontairApiToken") {
            return token
        }
        return nil;
    }
    
    private func setVolontairApiToken(token : String) {
        self.prefs.setObject(token, forKey: "VolontairApiToken")
    }
    
    private func getFacebookToken() -> String? {
        if let token = prefs.stringForKey("VolontairFacebookToken") {
            return token
        }
        return nil
    }
}