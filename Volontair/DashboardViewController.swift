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
    @IBOutlet weak var numberOfContactsLabel: UILabel!
    @IBOutlet weak var numberOfVolunteersLabel: UILabel!
    
    let dashboardService = DashboardServiceFactory.sharedInstance.getDashboardService()
    
    var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var userfirstname: String = ""
    
    override func viewDidAppear(animated: Bool) {
        
        userfirstname = prefs.stringForKey(ApiConfig.facebookUsernamePreference)!
        
        if welcomeLabel != nil {
            // Set welcome text with name
            welcomeLabel.text = "Welkom \(userfirstname)!, In de buurt zijn:"
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DashboardViewController.updateOnNotification), name: Config.dashboardNotificationKey, object: nil)
        setData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func setData(){
        let service = ServiceFactory.sharedInstance.dashboardService
        if let data = service.getDashboardModel(){
            numberOfVolunteersLabel.text = String(data.nearbyVolonteers)
            numberOfContactsLabel.text = String(data.potentialContacts)
        }
    }
    
    //This will be triggered once the Data is updated.
    func updateOnNotification() {
        setData()
    }
    
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) {
        print("Unwinded To Dashboard")
    }
}
