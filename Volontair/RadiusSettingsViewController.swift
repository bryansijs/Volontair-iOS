//
//  RadiusSettingsViewController.swift
//  Volontair
//
//  Created by Gebruiker on 5/24/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class RadiusSettingsViewController : UIViewController {
    
    @IBOutlet weak var radiusSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //radiusSlider?.value = Float(NSUserDefaults.standardUserDefaults().integerForKey(SettingsConstants.radiusKey))
        //onRadiusChanged(radiusSlider);
    }
    
    @IBAction func onRadiusChanged(sender: UISlider) {
        
                var currentValue = Int(sender.value)
        
                print("Change triggered")
        
                // update in steps of 5
                currentValue = Int(roundf(Float(currentValue) / SettingsConstants.radiusStepSize) * SettingsConstants.radiusStepSize);
                //radiusLabel.text = "\(currentValue)km"
        
                // persist to user defaults
                NSUserDefaults.standardUserDefaults().setInteger(currentValue, forKey: SettingsConstants.radiusKey)
        
    }
}
