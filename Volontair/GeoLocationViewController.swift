//
//  GeoLocationViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 04-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import CoreLocation

class GeoLocationViewController: UIViewController, ValidationProtocol {
    
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var radiusSliderLabel: UILabel!
    @IBOutlet weak var adressSubmitButton: UIButton!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var radiusSlider: UISlider!
    
    let locator = CLGeocoder()
    var validLocation = false
    
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
        
        // make textview look like textfield
        self.aboutMeTextView.layer.borderWidth = 0.5
        self.aboutMeTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.aboutMeTextView.layer.cornerRadius = 5;
        self.aboutMeTextView.clipsToBounds = true
    }
    
    func validate()-> Bool {
        return validLocation
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
            if(error != nil) {
                print(error!.localizedDescription)
                self.adressTextField.backgroundColor = UIColor(hue: 0.0028, saturation: 0.7, brightness: 0.89, alpha: 1.0)
            } else {
                self.adressTextField.backgroundColor = UIColor(hue: 0.475, saturation: 1, brightness: 0.74, alpha: 1.0)
                self.validLocation = true
                self.placeLabel.text = places![0].name

                print(places![0].country)
                print(places![0].postalCode)
                print(places![0].name)
                
            }
        }
    }
}
