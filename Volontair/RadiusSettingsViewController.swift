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
    @IBOutlet weak var radiusInKmLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().integerForKey(SettingsConstants.radiusKey) != 0 {
            let slideValue = NSUserDefaults.standardUserDefaults().integerForKey(SettingsConstants.radiusKey)
            radiusSlider?.value = Float(slideValue);
        } else {
            radiusSlider?.value = Float(10)
        }
        
        onRadiusChanged(radiusSlider)
    }
    
    override func viewWillDisappear(animated: Bool) {
        ServiceFactory.sharedInstance.dashboardService.loadDashboardDataFromServer({
        })
    }
    
    @IBAction func onRadiusChanged(sender: UISlider) {
                var currentValue = Int(sender.value)
                // update in steps of 5
                currentValue = Int(roundf(Float(currentValue) / SettingsConstants.radiusStepSize) * SettingsConstants.radiusStepSize);
                radiusInKmLabel.text = "\(currentValue)km"
                // persist to user defaults
                NSUserDefaults.standardUserDefaults().setInteger(currentValue, forKey: SettingsConstants.radiusKey)
    }
    
    
}
