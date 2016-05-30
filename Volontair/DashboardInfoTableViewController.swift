//
//  DashboardInfoTableViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 30-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class DashboardInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var numberOfContactsLabel: UILabel!
    
    @IBOutlet weak var numberOfVolunteersLabel: UILabel!
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("select")
    }
    
    func setLabels(numberOfContacts: String, numberOfVolunteers: String){
        self.numberOfContactsLabel.text = numberOfContacts
        self.numberOfVolunteersLabel.text = numberOfVolunteers
    }

}
