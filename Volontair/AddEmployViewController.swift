//
//  AddEmployViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 26-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class AddEmployViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
