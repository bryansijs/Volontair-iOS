//
//  SettingsViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 08-03-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

struct SettingsConstants {
    static let radiusStepSize: Float = 5
    
    static let radiusKey = "volontair.settings.radius"
}

class SettingsViewController: UITableViewController {
//    @IBOutlet weak var radiusCell: UITableViewCell!
//    @IBOutlet weak var radiusSlider: UISlider!
//    @IBOutlet weak var radiusLabel: UILabel!
    
    @IBOutlet weak var radiusCell: UITableViewCell!
    @IBOutlet weak var locationCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radiusCell.userInteractionEnabled = true
        locationCell.userInteractionEnabled = true
        
        let radiusTap = UITapGestureRecognizer(target: self, action: Selector("tapRadiusFunction:"))
        let locationTap = UITapGestureRecognizer(target: self, action: Selector("tapLocationFunction:"))
        
        radiusCell.addGestureRecognizer(radiusTap)
        locationCell.addGestureRecognizer(locationTap)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    func tapRadiusFunction(sender:UITapGestureRecognizer) {
        self.performSegueWithIdentifier("segueToRadiusSettings", sender: self)
    }
    
    func tapLocationFunction(sender:UITapGestureRecognizer) {
        self.performSegueWithIdentifier("segueToLocationSettings", sender: self)
    }
    
}
