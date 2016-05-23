//
//  CategoryTableViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 04-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController, ValidationProtocol {
        
    @IBOutlet var categoryTableView: UITableView!
    var selectedCell = 0
    var selectedCategories = [CategoryModel]()
    let wizardService = WizardServiceFactory.sharedInstance.wizardService
    let categoryService = ServiceFactory.sharedInstance.categoryService
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        
        cell.imageView?.image = categoryService.categories[indexPath.row].icon
        cell.textLabel?.text = categoryService.categories[indexPath.row].name
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedCell = indexPath.row
        let currentCell = categoryTableView.cellForRowAtIndexPath(indexPath)
        
        if(currentCell!.accessoryType != UITableViewCellAccessoryType.Checkmark){
            currentCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.selectedCategories.append(categoryService.categories[indexPath.row])
        } else {
            currentCell?.accessoryType = UITableViewCellAccessoryType.None
            let index = selectedCategories.indexOf{
                $0.name == categoryService.categories[indexPath.row].name
                }
            self.selectedCategories.removeAtIndex(index!)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return categoryService.categories.count
    }
    
    func validate()-> Bool {
        if(self.selectedCategories.count > 0){
            wizardService.setUserCategories(self.selectedCategories)
            return true
        } else {
            return false
        }
    }
}
