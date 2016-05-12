//
//  LoginViewController.swift
//  Volontair
//
//  Created by Gebruiker on 5/11/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import RxSwift

struct LoginViewControllerConstants {
    static let showFacebookModalSegue = "showfacebookmodalsegue"
}

class LoginViewController: UIViewController {
    
    var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let volontairApiService = VolontairApiService(controller: self)
        
        if self.isLoggedInToApi() != nil {
            volontairApiService.login()
        } else {
            if(isLoggedInToFacebook()) {
                volontairApiService.login(FBSDKAccessToken.currentAccessToken().tokenString)
            } else {
                self.performSegueWithIdentifier(LoginViewControllerConstants.showFacebookModalSegue, sender: self)
                
                return
            }
        }

    }
    
    func isLoggedInToApi() -> String? {
        if let token = prefs.stringForKey("VolontairApiToken") {
            return token
        } else {
            return nil
        }
    }
    
    // Function for checking if the user is logged in using Facebook
    func isLoggedInToFacebook() -> Bool {
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            //
            print("User already logged in")
            let token = FBSDKAccessToken.currentAccessToken()
            print(FBSDKAccessToken.currentAccessToken().tokenString)
            print(FBSDKAccessToken.currentAccessToken().description)
            
            return true
        }
        print("User not logged in")
        return false
    }
    
    
}