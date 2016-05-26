//
//  SettingsViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 08-03-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

struct SettingsConstants {
    static let radiusStepSize: Float = 5
    
    static let radiusKey = "volontair.settings.radius"
}

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var radiusCell: UITableViewCell!
    @IBOutlet weak var locationCell: UITableViewCell!
    @IBOutlet weak var interestsCell: UIView!
    @IBOutlet weak var logOutCell: UIView!
    
    var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 45, green: 183, blue: 207)
        radiusCell.userInteractionEnabled = true
        locationCell.userInteractionEnabled = true
        interestsCell.userInteractionEnabled = true;
        logOutCell.userInteractionEnabled = true;
        
        let radiusTap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.tapRadiusFunction(_:)))
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.tapLocationFunction(_:)))
        let interestsTap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.tapCategoriesFunction(_:)))
        let logOutTap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.LogoutApp(_:)))
        
        radiusCell.addGestureRecognizer(radiusTap)
        locationCell.addGestureRecognizer(locationTap)
        interestsCell.addGestureRecognizer(interestsTap)
        logOutCell.addGestureRecognizer(logOutTap)
        
        
    }
    

    override func viewWillAppear(animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    func tapRadiusFunction(sender:UITapGestureRecognizer) {
        self.performSegueWithIdentifier("segueToRadiusSettings", sender: self)
    }
    
    func tapLocationFunction(sender:UITapGestureRecognizer) {
        self.performSegueWithIdentifier("segueToLocationSettings", sender: self)
    }
    
    func tapCategoriesFunction(sender:UITapGestureRecognizer) {
        self.performSegueWithIdentifier("segueToCategorieSettings", sender: self)
    }
    
    func LogoutApp(sender:UITapGestureRecognizer) {
        self.prefs.removeObjectForKey("VolontairApiToken")
        self.prefs.removeObjectForKey("VolontairFacebookToken")
        self.performSegueWithIdentifier("segueToLoginView", sender: self)
    }
    
}
