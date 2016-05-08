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
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // set defaults
        let settingsDefaults = [
            SettingsConstants.radiusKey: 10 as Int
        ]
        defaults.registerDefaults(settingsDefaults)
        defaults.synchronize()
        
        // restore settings in view
        radiusSlider?.value = Float(NSUserDefaults.standardUserDefaults().integerForKey(SettingsConstants.radiusKey))
        onRadiusSliderValueChanged(radiusSlider);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRadiusSliderValueChanged(sender: UISlider) {
        var currentValue = Int(sender.value)
        
        print("Change triggered")
        
        // update in steps of 5
        currentValue = Int(roundf(Float(currentValue) / SettingsConstants.radiusStepSize) * SettingsConstants.radiusStepSize);
        radiusLabel.text = "\(currentValue)km"
        
        // persist to user defaults
        NSUserDefaults.standardUserDefaults().setInteger(currentValue, forKey: SettingsConstants.radiusKey)
    }
}
