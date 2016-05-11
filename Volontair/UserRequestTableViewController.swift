//
//  UserRequestTableViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 11-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class UserRequestTableViewController: UITableViewController {
    
    @IBOutlet var requestTableView: UITableView!
    
    let requestService = ServiceFactory.sharedInstance.requestService
    let userService = ServiceFactory.sharedInstance.userService
    let requests = [RequestModel]()
    
    
    override func viewWillAppear(animated: Bool) {
        //self.requestTableView.setEditing(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - UITableViewDataSource
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // let the controller to know that able to edit tableView's row
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // add the action button you want to show when swiping on tableView's cell , in this case add the delete button.
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action , indexPath) -> Void in
            // Your delete code here.....
            print("delete")
        })
        
        // You can set its properties like normal button
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return userService.userModel!.requests.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        
        cell.imageView?.image = UIImage(named: "icon_housekeeping")
        cell.textLabel?.text = userService.userModel?.requests[indexPath.row].title
        
        return cell
    }
}
