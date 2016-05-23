//
//  EditProfileViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 23-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    let userService = ServiceFactory.sharedInstance.userService

    @IBAction func saveButtonPressed(sender: UIButton) {
        
    }
    @IBAction func backButtonPressed(sender: UIButton) {
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
