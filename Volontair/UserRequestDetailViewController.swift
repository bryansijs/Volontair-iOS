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

    var editMode = true
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var requestCategoryLabel: UILabel!
    @IBOutlet weak var ownerUIImageView: UIImageView!
    @IBOutlet weak var OwnerNameLabel: UILabel!

    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var requestDateLabel: UILabel!
    
    
    override func viewDidLoad() {
        self.configureView()
        detailTextView.editable = false
        saveButton.hidden = true
        prepareEditMode()
    }
    
    override func viewDidLayoutSubviews(){
        self.titleTextView.setContentOffset(CGPointZero, animated: false)
    }

    // show edit button?
    private func prepareEditMode(){
        if(!editMode){
            self.editButton.hidden = true
            self.titleTextView.editable = false
        } else {
            self.chatButton.hidden = true
        }
    }
    
    func configureView(){
        self.titleTextView.text = detailItem?.title
        self.detailTextView.text = detailItem?.summary
        self.OwnerNameLabel.text = detailItem?.owner?.name
        
        if let category = detailItem?.categorys?.first?.name{
            self.requestCategoryLabel.text = category
        }
        self.requestDateLabel.text = detailItem?.created!.regex("^([0-9]*-[0-9]*)*")[0]
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        self.detailItem?.title = titleTextView.text!
        self.detailItem?.summary = detailTextView.text!
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func editButtonPressed(sender: UIButton) {
        self.saveButton.hidden = false
        self.detailTextView.editable = true
        
    }
    override func viewWillAppear(animated: Bool) {
        //self.requestTableView.setEditing(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
