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
    let currentUser = ServiceFactory.sharedInstance.userService.getCurrentUser()
    
    override func viewDidLoad() {
        self.nameTextField.text = currentUser?.name
        setPlaceField()
    }
    
    private func setPlaceField(){
        self.locManager.stopUpdatingLocation()
        let location = CLLocation(latitude: currentUser!.latitude, longitude: currentUser!.longitude)
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: NSError?) in
            let placeMark = placemarks?[0]
            print(placeMark?.addressDictionary)
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
    }

    @IBAction func currentLocationButtonPressed(sender: UIButton) {
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    @IBAction func saveButtonPressed(sender: UIButton) {
        
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
