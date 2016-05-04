//
//  GeoLocationViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 04-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import CoreLocation

class GeoLocationViewController: UIViewController {
    
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var radiusSliderLabel: UILabel!
    @IBOutlet weak var adressSubmitButton: UIButton!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var radiusSlider: UISlider!
    
    let locator = CLGeocoder()
    
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
        sliderValueChanged(radiusSlider);
    }

    
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        var currentValue = Int(sender.value)
    
        // update in steps of 5
        currentValue = Int(roundf(Float(currentValue) / SettingsConstants.radiusStepSize) * SettingsConstants.radiusStepSize);
        radiusSliderLabel.text = "\(currentValue)km"
        
        // persist to user defaults
        NSUserDefaults.standardUserDefaults().setInteger(currentValue, forKey: SettingsConstants.radiusKey)
    }
    
    @IBAction func adressSubmitButtonPressed(sender: UIButton) {
        locator.geocodeAddressString(adressTextField.text!) { (places: [CLPlacemark]?,error: NSError?) in
            print(places![0].location)
        }
    }
}
