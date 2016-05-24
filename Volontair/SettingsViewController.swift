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
//    @IBOutlet weak var radiusCell: UITableViewCell!
//    @IBOutlet weak var radiusSlider: UISlider!
//    @IBOutlet weak var radiusLabel: UILabel!
    
    @IBOutlet weak var radiusCell: UITableViewCell!
    @IBOutlet weak var locationCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radiusCell.userInteractionEnabled = true
        locationCell.userInteractionEnabled = true
        
        let radiusTap = UITapGestureRecognizer(target: self, action: Selector("tapRadiusFunction:"))
        let locationTap = UITapGestureRecognizer(target: self, action: Selector("tapLocationFunction:"))
        
        radiusCell.addGestureRecognizer(radiusTap)
        locationCell.addGestureRecognizer(locationTap)
        
        // restore settings in view
//        radiusSlider?.value = Float(NSUserDefaults.standardUserDefaults().integerForKey(SettingsConstants.radiusKey))
//        onRadiusSliderValueChanged(radiusSlider);
    }
    
    func tapRadiusFunction(sender:UITapGestureRecognizer) {
        self.performSegueWithIdentifier("segueToRadiusSettings", sender: self)
    }
    
    func tapLocationFunction(sender:UITapGestureRecognizer) {
        self.performSegueWithIdentifier("segueToLocationSettings", sender: self)
    }
    
//    @IBAction func onRadiusSliderValueChanged(sender: UISlider) {
//        var currentValue = Int(sender.value)
//        
//        print("Change triggered")
//        
//        // update in steps of 5
//        currentValue = Int(roundf(Float(currentValue) / SettingsConstants.radiusStepSize) * SettingsConstants.radiusStepSize);
//        radiusLabel.text = "\(currentValue)km"
//        
//        // persist to user defaults
//        NSUserDefaults.standardUserDefaults().setInteger(currentValue, forKey: SettingsConstants.radiusKey)
//    }
}
