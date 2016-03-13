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

class FacebookViewController: UIViewController, FBSDKLoginButtonDelegate {

    struct FacebookViewControllerConstants {
        static let usernamePreference = "Username"
        static let showDashboardSegue = "showDashboard"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not logged in")
        }
        else
        {
            print("logged in")
        }
        
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
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier != FacebookViewControllerConstants.showDashboardSegue) {
            return
        }
        
        let request = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"name,gender,birthday,first_name,last_name,email"]);
        request.startWithCompletionHandler {
            (connection, result, error) in
            if error != nil {
                print ("error \(error)")
                return
            }
                
            if let userData = result as? NSDictionary {
                    
                let firstname = userData["first_name"] as? String
                    
                print(result)

                //Save username in settings
                let prefs = NSUserDefaults.standardUserDefaults()
                prefs.setObject(firstname, forKey: FacebookViewControllerConstants.usernamePreference)
                
                let svc = segue.destinationViewController as! DashboardViewController;
                svc.userfirstname = firstname
            }
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if(error != nil) {
            print(error.localizedDescription)
            return
        }
        
        print("login completed")
        
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true);
        FBSDKAccessToken.currentAccessToken().userID
        
        self.performSegueWithIdentifier(FacebookViewControllerConstants.showDashboardSegue, sender: self)
        
        print("Redirect user to Dashboard")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.removeObjectForKey(FacebookViewControllerConstants.usernamePreference)
        print("preference deleted")
        print("user logged out")
    }
}
