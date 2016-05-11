//
//  UserRequestDetailViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 11-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class UserRequestDetailViewController: UIViewController {
    
    var detailItem: RequestModel? {
        didSet {
            // Update the view.
            //self.configureView()
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        self.configureView()
    }
    
    func configureView(){
        self.titleLabel.text = detailItem?.title
        self.detailTextView.text = detailItem?.summary
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.requestTableView.setEditing(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
