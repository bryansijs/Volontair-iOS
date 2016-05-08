//
//  UserTypeViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 04-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class UserTypeViewController: UIViewController, ValidationProtocol {

    var userWillCreateRequests = true
    var userWillCreateOffers = true
    
    func validate()-> Bool {
        if (userWillCreateRequests || userWillCreateOffers){
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
