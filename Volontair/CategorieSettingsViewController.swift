//
//  CategorieViewController.swift
//  Volontair
//
//  Created by Gebruiker on 5/25/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import UIKit

class CategorieSettingsViewController : UITableViewController {
    
    @IBOutlet var categoryTableView: UITableView!
    
    var selectedCell = 0
    var selectedCategories = [CategoryModel]()
    let categoryService = ServiceFactory.sharedInstance.categoryService
    let userService = ServiceFactory.sharedInstance.userService
    
    @IBOutlet weak var errorCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategorieCell", forIndexPath: indexPath)
        
        cell.imageView?.image = categoryService.categories[indexPath.row].icon
        cell.textLabel?.text = categoryService.categories[indexPath.row].name
        if self.checkAlreadySelectedCategories(categoryService.categories[indexPath.row]) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.selectedCategories.append(categoryService.categories[indexPath.row])
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedCell = indexPath.row
        let currentCell = categoryTableView.cellForRowAtIndexPath(indexPath)
        
        if(currentCell!.accessoryType != UITableViewCellAccessoryType.Checkmark){
            currentCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.selectedCategories.append(categoryService.categories[indexPath.row])
        } else {
            if(self.selectedCategories.count > 1) {
                currentCell?.accessoryType = UITableViewCellAccessoryType.None
                let index = selectedCategories.indexOf{
                    $0.name == categoryService.categories[indexPath.row].name
                }
                self.selectedCategories.removeAtIndex(index!)
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return categoryService.categories.count
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            for userCategorie : CategoryModel in userService.getCurrentUser()!.categorys! {
                var found : Bool = false
                for selectedCategorie : CategoryModel in self.selectedCategories {
                    if(selectedCategorie.name == userCategorie.name) {
                        found = true
                    }
                }
                if !found {
                    userService.deleteUserCategoryServer(userCategorie)
                }
            }
            
            userService.getCurrentUser()?.categorys = self.selectedCategories
            userService.saveUserCategoryOnServer()
        }
    }
    
    func checkAlreadySelectedCategories(categorie : CategoryModel) -> Bool{
        for userCategorie : CategoryModel in userService.getCurrentUser()!.categorys! {
            if categorie.name == userCategorie.name {
                return true
            }
        }
        return false
    }

}
