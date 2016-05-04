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
    var selectedCategories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        print("appeared")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedCell = indexPath.row
        let currentCell = categoryTableView.cellForRowAtIndexPath(indexPath)
        
        if(currentCell!.accessoryType != UITableViewCellAccessoryType.Checkmark){
            
            currentCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedCategories.append((categoryTableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text!)!)
            print(selectedCategories)
        } else {
            currentCell?.accessoryType = UITableViewCellAccessoryType.None
            let index = selectedCategories.indexOf(currentCell!.textLabel!.text!)
            selectedCategories.removeAtIndex((index!.littleEndian))
            print(selectedCategories)
        }
    }
    
    func validate()-> Bool {
        
        return self.selectedCategories.count > 0
    }
}
