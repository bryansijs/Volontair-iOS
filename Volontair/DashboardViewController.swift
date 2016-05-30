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
    
    private var embeddedViewController: DashboardInfoTableViewController!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    let dashboardService = DashboardServiceFactory.sharedInstance.getDashboardService()
    
    var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var userfirstname: String = ""
    
    override func viewDidAppear(animated: Bool) {
        
        userfirstname = prefs.stringForKey(ApiConfig.facebookUsernamePreference)!
        
        if welcomeLabel != nil {
            // Set welcome text with name
            welcomeLabel.text = "Welkom \(userfirstname)!"
        }
        
        containerView.userInteractionEnabled = true;
        let tap = UITapGestureRecognizer(target: self, action: #selector(DashboardViewController.tapFunction(_:)))
        containerView.addGestureRecognizer(tap)
        
        setData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DashboardViewController.updateOnNotification), name: Config.dashboardNotificationKey, object: nil)

    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DashboardInfoTableViewController
            where segue.identifier == "embedSeque" {
            
            self.embeddedViewController = vc
        }
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        self.tabBarController!.selectedIndex = 2
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
            self.embeddedViewController.setLabels(String(data.potentialContacts), numberOfVolunteers: String(data.nearbyVolonteers))
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
