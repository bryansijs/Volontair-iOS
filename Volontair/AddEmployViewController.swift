//
//  AddEmployViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 26-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class AddEmployViewController: UIViewController {

    @IBOutlet weak var offerView: UIView!
    

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        offerView.hidden = true
    }
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
            case 0: offerView.hidden = true
            case 1: offerView.hidden = false
            default: offerView.hidden = true
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
