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
    @IBAction func StartConversating(sender: AnyObject) {
        let email = detailItem?.owner?.username
        let subject = detailItem?.summary
        
        //?cc=bar@example.com&subject=Greetings%20from%20Cupertino!&body=Wish%20you%20were%20here!
        let url = NSURL(string: "mailto:"+email!+"?subject="+subject!)
        
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        } else {
            let alert = UIAlertView()
            alert.title = "Contact with this user is not possible"
            alert.message = "The other user is informed of this problem, Try again later"
            alert.addButtonWithTitle("ok")
            alert.show()
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
