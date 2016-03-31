//
//  FacebookViewController.swift
//  Volontair
//
//  Created by M Mommersteeg on 12/03/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

struct FacebookViewControllerConstants {
    static let usernamePreference = "volontair.preferences.username"
    static let showDashboardSegue = "unwindToDashboard"
}

class FacebookViewController: UIViewController, FBSDKLoginButtonDelegate {

    var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(FBSDKAccessToken.currentAccessToken() != nil) {
            print("User already logged in")
            redirectToDashboard()
            return
        }
        print("Not logged in")
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        
        loginButton.delegate = self
        
        self.view.addSubview(loginButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if(error != nil) {
            print(error.localizedDescription)
            return
        }
        
        let request = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"name,gender,birthday,first_name,last_name,email"]);
        request.startWithCompletionHandler {
            (connection, result, error) in
            if error != nil {
                print ("error \(error)")
                return
            }
            print("login succeeded")
            
            if let userData = result as? NSDictionary {
                
                let firstname = userData["first_name"] as? String
                
                print("Retrieved data from Facebook:")
                print(result)
                
                //Save username in settings
                self.prefs.setObject(firstname, forKey: FacebookViewControllerConstants.usernamePreference)
                self.prefs.synchronize()
                
                print("username preference added")
                
                self.redirectToDashboard()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        prefs.removeObjectForKey(FacebookViewControllerConstants.usernamePreference)
        print("username preference deleted")
        print("user logged out")
    }
    
    func redirectToDashboard() {
        self.performSegueWithIdentifier(FacebookViewControllerConstants.showDashboardSegue, sender: self)
    }
}
