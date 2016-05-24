//
//  LocationSettingsViewController.swift
//  Volontair
//
//  Created by Gebruiker on 5/24/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import CoreLocation

class LocationSettingsViewController : UIViewController {
    

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var adressTextField: UITextField!
    
    let locator = CLGeocoder()
    let settingsService = SettingsService()
    var latitude :Double?
    var longitude : Double?
    var validLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = ServiceFactory.sharedInstance.userService.getCurrentUser() {
            if user.longitude != 0 && user.latitude != 0 {
                self.setUsersClosestCity(user.latitude, long: user.longitude)
            }
        }
    }
    
    @IBAction func adressSubmitButtonPressed(sender: UIButton) {
        
        locator.geocodeAddressString(adressTextField.text!) { (places: [CLPlacemark]?,error: NSError?) in
            if(error != nil) {
                print(error!.localizedDescription)
                self.adressTextField.backgroundColor = UIColor(hue: 0.0028, saturation: 0.7, brightness: 0.89, alpha: 1.0)
            } else {
                self.adressTextField.backgroundColor = UIColor(hue: 0.475, saturation: 1, brightness: 0.74, alpha: 1.0)
                self.validLocation = true
                self.placeLabel.text = places![0].name! + places![0].administrativeArea!
                self.latitude = Double((places![0].location?.coordinate.latitude.description)!)
                self.longitude = Double((places![0].location?.coordinate.longitude.description)!)
                self.settingsService.updateCurrentUserLocation(self.latitude!, longitude: self.longitude!)
            }
        }
    }
    
    func setUsersClosestCity(lat: Double, long : Double)
    {
        let myLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: myLocation.latitude, longitude: myLocation.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            var streetName : String?
            var townName : String?
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary)
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                streetName = street as String
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                townName = city as String
            }
            
            if(streetName != nil && townName != nil) {
                self.placeLabel.text = " \(streetName!)"+" "+"\(townName!)"
            }
        })
    
    }

}