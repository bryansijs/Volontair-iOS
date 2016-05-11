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
    
    let viewController: UIViewController
    
    var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    let baseOnlineUrl = "http://volontair.herokuapp.com"
    let baseUrl = "http://volontair.herokuapp.com"//"http://192.168.178.49:6789"
    let registerFacebookTokenUrl = "/auth/facebook/client?accessToken=";
    let getVolontairApiTokenUrl = "/oauth/authorize?response_type=token&client_id=volontair&redirect_uri=/";
    let getMeUrl = "/api/v1/users/me"
    //let tempvolontairToken = "fca4a7c6-23c0-4974-82e1-3d2e2e29c9d9"
    
    init(controller: UIViewController) {
        viewController = controller
    }
    
    internal func login(facebookToken: String) {
        self.loginApi(self.getFacebookToken()!)
    }
    
    internal func login() {
        if self.getVolontairApiToken() != "" {
            self.checkApiAuthentication(self.getVolontairApiToken())
            
        } else {
            
            if self.getFacebookToken() != "" {
                self.loginApi(self.getFacebookToken()!)
                
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
                    

                    if let name = JSON["name"] {
                        print("Jep data is legetiem \(name)")
                        self.setGlobalHeaders(headers)
                        self.setVolontairApiToken(volontairToken)
                        
                    } else {
                        print("shit dit go wrong")
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    private func loginFacebook() {
        viewController.performSegueWithIdentifier(DashboardViewControllerConstants.showFacebookModalSegue, sender: self)
        return
    }
    
    private func goToDashboardView() {
        viewController.performSegueWithIdentifier(FacebookViewControllerConstants.showDashboardSegue, sender: viewController)
    }
    
    private func loginApi(facebookToken : String) {
        let headers = [ "Content-Type" : "application/json" ]
        
        Alamofire.request(.GET, self.baseUrl + self.registerFacebookTokenUrl + facebookToken , headers: headers)
            .responseData { response in
                print(response.response)
                print(response.result)
                
                Alamofire.request(.GET, self.baseUrl + self.getVolontairApiTokenUrl, headers: headers, encoding: .JSON)
                    .responseString() { response in
                        
                        print(response.response)
                        print(response.result)
                        
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
    private func getVolontairApiToken() -> String? {
        if let token = prefs.stringForKey("VolontairApiToken") {
            return token
        }
        return nil;
    }
    
    private func setVolontairApiToken(token : String) {
        self.prefs.setObject(token, forKey: "VolontairApiToken")
    }
    
    private func getFacebookToken() -> String? {
        //gnpiwano TODO token specifieker zetten mischien.
        if let token = prefs.stringForKey("VolontairFacebookToken") {
            return token
        }
        return nil
    }
}