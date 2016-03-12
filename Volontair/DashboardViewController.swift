//
//  DashboardViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 11-03-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit


class DashboardViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    var dataPassed: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set welcome text with name
        welcomeLabel.text = "Hello \(dataPassed)!"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
