//
//  GeoLocationViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 04-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import CoreLocation

class GeoLocationViewController: UIViewController, ValidationProtocol, UITextViewDelegate {
    
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var radiusSliderLabel: UILabel!
    @IBOutlet weak var adressSubmitButton: UIButton!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var radiusSlider: UISlider!
    
    let locator = CLGeocoder()
    let wizardService = WizardServiceFactory.sharedInstance.wizardService
    var latitude :Double?
    var longitude : Double?
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
        self.aboutMeTextView.returnKeyType = UIReturnKeyType.Done
        self.aboutMeTextView.delegate = self
        
        self.addDoneButtonOnKeyboard()

    }
    
    func validate()-> Bool {
        if(validLocation && self.aboutMeTextView.text != ""){
            wizardService.setUserLocationProperties(self.latitude!, longtitude: self.longitude!, description: self.aboutMeTextView.text)
            return true
        }
        return false
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
                self.placeLabel.text = NSLocalizedString("PLACE",comment: "") + places![0].name!
                self.latitude = Double((places![0].location?.coordinate.latitude.description)!)
                self.longitude = Double((places![0].location?.coordinate.longitude.description)!)
//                print(places![0].country)
//                print(places![0].postalCode)
            }
        }
    }
    
    //MARK: textviewDelegate
    
    func addDoneToolBarToKeyboard(textview :UITextView){
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = .BlackTranslucent

        
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = .Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(GeoLocationViewController.doneButtonAction))
        
        var items: [UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.aboutMeTextView.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.aboutMeTextView.resignFirstResponder()
    }
    
    override func disablesAutomaticKeyboardDismissal() -> Bool {
        return false
    }
}
