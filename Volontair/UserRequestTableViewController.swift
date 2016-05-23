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
    var requests = [RequestModel]()
    let requestsFromCurrentUser = true
    
    var editMode = true
    
    override func viewWillAppear(animated: Bool) {
        //self.requestTableView.setEditing(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Aanvragen"
        
        if (requestsFromCurrentUser){
            if(userService.userModel!.requests?.count > 0){
                requests = userService.userModel!.requests!
            }
        }
        self.requestTableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - UITable Delete functionality
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // let the controller to know that able to edit tableView's row
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // needs to be overwritten but can be empty
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if(editMode){
            let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action , indexPath) -> Void in
                // Your delete code here.....
                let request = self.requests[indexPath.row]
                self.requestService.deleteUserRequest(request)
                self.requests.removeAtIndex(indexPath.row)
                if(self.requests.count < 1){
                      self.navigationController?.popViewControllerAnimated(true)
                }
                self.tableView.reloadData()
            })
            
            // You can set its properties like normal button
            deleteAction.backgroundColor = UIColor.redColor()
            
            return [deleteAction]
        } else {
            return nil
        }
    }
    
    
    // MARK: - UITableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.requests.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        
        cell.imageView?.image = UIImage(named: "icon_housekeeping")
        cell.textLabel?.text = self.requests[indexPath.row].title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        performSegueWithIdentifier("showUserRequestDetail", sender: currentCell)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUserRequestDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let request = self.requests[indexPath.row]
                let controller = (segue.destinationViewController as! UserRequestDetailViewController)
                controller.detailItem = request
                controller.editMode = self.editMode
            }
        }
    }
}
