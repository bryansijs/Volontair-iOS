//
//  DashboardViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 11-03-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import FBSDKLoginKit

struct DashboardViewControllerConstants {
    static let showFacebookModalSegue = "showfacebookmodalsegue"
}

class DashboardViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var userfirstname: String! = ""
    
    override func viewDidAppear(animated: Bool) {
        if(!isLoggedIn()) {
            self.performSegueWithIdentifier(DashboardViewControllerConstants.showFacebookModalSegue, sender: self)
            return
        }
        userfirstname = prefs.stringForKey(FacebookViewControllerConstants.usernamePreference)
        if welcomeLabel != nil {
            // Set welcome text with name
            welcomeLabel.text = "Welcome \(userfirstname)!"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function for checking if the user is logged in using Facebook
    func isLoggedIn() -> Bool {
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            //
            print("User already logged in")
            return true
        }
        print("User not logged in")
        return false
    }
    
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) {
        print("Unwinded To Dashboard")
    }
}
