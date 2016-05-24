//
//  EditProfileViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 23-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import MapKit

class EditProfileViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    let geoCoder = CLGeocoder()
    let locManager = CLLocationManager()
    let userService = ServiceFactory.sharedInstance.userService
    let profileService = ProfileServiceFactory.sharedInstance.profileService
    let currentUser = ServiceFactory.sharedInstance.userService.getCurrentUser()
    
    override func viewDidLoad() {
        // make textview look like textfield
        self.aboutMeTextView.layer.borderWidth = 0.5
        self.aboutMeTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.aboutMeTextView.layer.cornerRadius = 5;
        self.aboutMeTextView.clipsToBounds = true
        self.automaticallyAdjustsScrollViewInsets = false
        setData()
    }
    
    private func setData(){
        self.nameTextField.text = currentUser?.name
        self.aboutMeTextView.text = currentUser?.summary
        setPlaceField()
    }
    
    override func viewWillAppear(animated: Bool) {
        setData()
    }
    
    private func setPlaceField(){
        self.locManager.stopUpdatingLocation()
        let location = CLLocation(latitude: currentUser!.latitude, longitude: currentUser!.longitude)
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: NSError?) in
            let placeMark = placemarks?[0]
            self.placeTextField.text = placeMark!.addressDictionary!["Street"] as? String
        }
    }
    
    // MARK: - Location Delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        self.currentUser?.latitude = locations[0].coordinate.latitude
        self.currentUser?.longitude = locations[0].coordinate.longitude
        setPlaceField()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
        
        let alertController = UIAlertController(title: NSLocalizedString("LOCATION",comment: ""), message:
            NSLocalizedString("CANTUPDATELOC",comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func currentLocationButtonPressed(sender: UIButton) {
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        if validate() {
            currentUser?.name = self.nameTextField.text!
            currentUser?.summary = self.aboutMeTextView.text
            // location allready in currentUser
            profileService.saveEditedProfile()
            closeView()
        }
    }
    
    private func validate() -> Bool {
        if self.nameTextField.text?.characters.count < 8 {
            let alertController = UIAlertController(title: NSLocalizedString("NAME",comment: ""), message:
                NSLocalizedString("MINIMUM_NAME_LENGHT",comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }

    
    @IBAction func nameTextFieldDidEndEdit(sender: UITextField) {
        validate()
    }
    private func closeView(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        closeView()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
