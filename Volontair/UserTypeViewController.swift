//
//  UserTypeViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 04-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class UserTypeViewController: UIViewController, ValidationProtocol {

    var userWillCreateRequests = false
    var userWillCreateOffers = true
    
    let wizardService = WizardServiceFactory.sharedInstance.wizardService
    
    func validate()-> Bool {
        if (userWillCreateRequests || userWillCreateOffers){
            wizardService.setUserTypeProperties(userWillCreateOffers, limited: userWillCreateRequests)
            return true
        } else {
            return false
        }
    }
    
    @IBAction func requestSwitchValueChanged(sender: UISwitch) {
        userWillCreateRequests = sender.on
    }
    
    @IBAction func offerSwitchValueChanged(sender: UISwitch) {
        userWillCreateOffers = sender.on
    }
}
