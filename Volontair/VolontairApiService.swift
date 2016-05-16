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
    let userService : UserService
    
    init() {
        userService = ServiceFactory.sharedInstance.getUserService()
    }
    
    internal func login(facebookToken: String , completionHandler:()->Void, completionErrorhandler:()->Void? ) {
        if let token = getVolontairApiToken() {
            self.checkApiAuthentication(token, completeSuccesHandler: completionHandler, completeErrorHandler: completionErrorhandler)
        } else {
            self.loginApi(facebookToken, completeSuccseHandler: completionHandler, completeErrorHandler: completionErrorhandler )
        }
    }
    
    internal func login(completeSuccesHandler:()->Void, completeErrorHandler:()->Void ) {
        if let token = getVolontairApiToken() {
            self.checkApiAuthentication(token, completeSuccesHandler: completeSuccesHandler, completeErrorHandler: completeErrorHandler)
        } else {
            completeErrorHandler()
        }
    }
    
    private func checkApiAuthentication(volontairToken : String, completeSuccesHandler:()->Void? , completeErrorHandler:()->Void?) {
        let headers = [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(volontairToken)"
        ]
        
        Alamofire.request(.GET, ApiConfig.baseUrl + ApiConfig.getMeUrl, headers: headers, encoding: .JSON)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    
                    if let name = JSON["name"] {
                        if(name != nil) {
                            print("Jep data is legetiem \(name)")
                            self.setGlobalHeaders(headers)
                            print("VolontairApiToken = ",volontairToken)
                            
                            if let value = response.result.value {
                                let user = UserModel(jsonData: value)
                                self.userService.setCurrentUser(user)
                                
                                //self.userService.loadUserOffers(user)
                                self.userService.loadUserRequests(user)
                                self.userService.loadUserCategorys(user)
                            }
                            
                            self.setVolontairApiToken(volontairToken)
                            completeSuccesHandler()
                        } else {
                            self.prefs.removeObjectForKey("VolontairApiToken")
                            self.prefs.removeObjectForKey("VolontairFacebookToken")
                            completeErrorHandler()
                        }
                    } else {
                        
                        print("shit dit go wrong")
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    
    private func loginApi(facebookToken : String, completeSuccseHandler:()->Void?, completeErrorHandler:()->Void?) {
        let headers = [ "Content-Type" : "application/json" ]
        
        Alamofire.request(.GET, ApiConfig.registerFacebookTokenUrl + facebookToken , headers: headers)
            .responseData { response in
                
                Alamofire.request(.GET, ApiConfig.getVolontairApiTokenUrl, headers: headers, encoding: .JSON)
                    .responseString() { response in
                        
                        
                        let URL = response.response?.URL?.fragments //In extension/NSURLFragmentExtension
                        
                        if URL?.count > 0 {
                            print(URL!["access_token"])
                            self.checkApiAuthentication(URL!["access_token"]!, completeSuccesHandler: completeSuccseHandler, completeErrorHandler: completeErrorHandler);
                        } else {
                            //Facebook token is wrong
                        }
                }
        }
    }
    
    private func setGlobalHeaders(headers : [String: String]) {
        ApiConfig.headers = headers;
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