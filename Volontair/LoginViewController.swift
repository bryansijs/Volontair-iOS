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
    @IBOutlet weak var facebookInlogButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()
        
        if volontairApiService.getVolontairApiToken() != nil {
            volontairApiService.login(self.loadMinimalDataForApplicationStart , completeErrorHandler: self.error)
        }else {
            self.hideLoading()
        }
        
    }
    
    @IBAction func btnFacebookLogin(sender: AnyObject) {
        if !activityIndicator.isAnimating() {
            
            self.showLoading()
            
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) -> Void in
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result
                    if let permission = fbloginresult.grantedPermissions {
                        if(fbloginresult.grantedPermissions.contains("email"))
                        {
                            //maak request voor standaard data en token
                            self.getFBUserData()
                        }
                    } else {
                        self.error()
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
        
                        self.volontairApiService.login(token, completionHandler: self.loadMinimalDataForApplicationStart, completionErrorhandler: self.error)
                        
                        //Save username & token in settings
        
                        self.prefs.setObject(firstname, forKey: ApiConfig.facebookUsernamePreference)
                        self.prefs.setObject(token ,forKey: "VolontairFacebookToken")
                        
                        self.prefs.synchronize()
                    }
            })
        }
    }
    
    func redirectToNextView() -> Void {
        let lat = ServiceFactory.sharedInstance.userService.getCurrentUser()?.latitude
        initAppData()
        
        if(lat == nil || lat == 0) {
            self.performSegueWithIdentifier(LoginViewControllerConstants.showWizardSegue, sender: self)
        } else {
            self.performSegueWithIdentifier(LoginViewControllerConstants.showDashboardSegue, sender: self)
        }

    }
    
    func initAppData(){
        ServiceFactory.sharedInstance.categoryService.loadCategories()
    }
    
    func error() {
        self.hideLoading()
        print("Something went wrong")
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func loadMinimalDataForApplicationStart() {
        self.loadDashBoardData(self.redirectToNextView)
    }
    
    func loadDashBoardData(completionHandler:() -> Void) {
        ServiceFactory.sharedInstance.dashboardService.loadDashboardDataFromServer(self.redirectToNextView)
    }
    
    func hideLoading() {
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
        facebookInlogButton.hidden = false
    }
    
    func showLoading() {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        facebookInlogButton.hidden = true
    }
    
}