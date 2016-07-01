//
//  DisclaimerViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 27-06-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController, ValidationProtocol {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var acceptUISwitch: UISwitch!
    
    override func viewDidLoad() {
        UIWebView.loadRequest(webView)(NSURLRequest(URL: NSURL(string: ApiConfig.disclaimerURL)!))
    }
    
    func validate()-> Bool {
        return acceptUISwitch.on
    }
}
