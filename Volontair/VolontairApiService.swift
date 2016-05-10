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

class VolontairApiService {
    
    let baseUrl = "http://192.168.178.49:6789"
    let registerFacebookTokenUrl = "/auth/facebook/client?accessToken=";
    let getVolontairApiTokenUrl = "/oauth/authorize?response_type=token&client_id=volontair&redirect_uri=/";
    let getMeUrl = "/users/me"
    //let tempvolontairToken = "fca4a7c6-23c0-4974-82e1-3d2e2e29c9d9"
    
    init() {
        
    }
    
    internal func login(facebookToken: String) {
        self.setFacebookToken(facebookToken)
        self.loginApi(self.getFacebookToken())
    }
    
    internal func login() {
        if self.getVolontairApiToken() != "" {
            self.checkApiAuthentication(self.getVolontairApiToken())
            
        } else {
            
            if self.getFacebookToken() != "" {
                self.loginApi(self.getFacebookToken())
                
            } else {
                self.loginFacebook()
                
            }
        }
    }
    
    private func checkApiAuthentication(volontairToken : String) {
        let headers = [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(volontairToken)"
        ]
        
        Alamofire.request(.GET, self.baseUrl + self.getMeUrl, headers: headers, encoding: .JSON)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    //TODO hier kijken of je het goede JSON object terugkrijg en ander is de gebruiker nog steeds ingelogd.
                    // if good
                    self.setGlobalHeaders(headers)
                    print("Success with JSON: \(JSON)")
                    //let response = JSON as! NSDictionary
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    private func loginFacebook() {
        
    }
    
    private func loginApi(facebookToken : String) {
        let headers = [ "Content-Type" : "application/json" ]
        
        Alamofire.request(.GET, self.baseUrl + self.registerFacebookTokenUrl + facebookToken , headers: headers)
            .responseData { response in
                
                Alamofire.request(.GET, self.baseUrl + self.getVolontairApiTokenUrl, headers: headers, encoding: .JSON)
                    .responseString() { response in
                        
                        let URL = response.response?.URL?.fragments //In extension/NSURLFragmentExtension
                        
                        if URL?.count > 0 {
                            self.checkApiAuthentication(URL!["access_token"]!);
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
    private func getVolontairApiToken() -> String {
        return Config.VolontairApiToken;
    }
    
    private func setVolontairApiToken(token : String) {
        Config.VolontairApiToken = token
    }
    
    private func getFacebookToken() -> String {
        return Config.facebookToken;
    }
    
    private func setFacebookToken(token : String) {
        Config.facebookToken = token
    }
    
}