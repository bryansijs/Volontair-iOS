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

struct LoginViewControllerConstants {
    static let showDashboardSegue = "showDashBoardSegue"
    static let showWizardSegue = "showWizardSegue"
}

class LoginViewController: UIViewController {
    
    var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let volontairApiService = VolontairApiService()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        
        if let token = volontairApiService.getVolontairApiToken() {
            volontairApiService.login(self.redirectToNextView , completeErrorHandler: self.error)
        }else {
            activityIndicator.hidden = true
            activityIndicator.stopAnimating()
        }
        
    }
    
    @IBAction func btnFacebookLogin(sender: AnyObject) {
        if !activityIndicator.isAnimating() {
            
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) -> Void in
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        //maak request voor standaard data en token
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name,gender,birthday,first_name,last_name,email"])
                .startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error != nil){
                    print("getFBUserData error \(error)");
                }
                    
                    if let userData = result as? NSDictionary {
                        let firstname = userData["first_name"] as? String
                        let token = FBSDKAccessToken.currentAccessToken().tokenString
        
                        print("Retrieved data from Facebook:")
                        print(result)
        
                        self.volontairApiService.login(token, completionHandler: self.redirectToNextView, completionErrorhandler: self.error)
                        
                        //Save username & token in settings
        
                        self.prefs.setObject(firstname, forKey: ApiConfig.facebookUsernamePreference)
                        self.prefs.setObject(token ,forKey: "VolontairFacebookToken")
                        
                        self.prefs.synchronize()
                    }
            })
        }
    }
    
    func redirectToNextView() {
        let lat = ServiceFactory.sharedInstance.userService.getCurrentUser()?.latitude
        
//        if(lat == nil || lat == "") {
//            self.performSegueWithIdentifier(LoginViewControllerConstants.showWizardSegue, sender: self)
//        } else {
            self.performSegueWithIdentifier(LoginViewControllerConstants.showDashboardSegue, sender: self)
//        }

    }
    
    func error() {
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
        print("Something went wrong")
    }
    
    
}