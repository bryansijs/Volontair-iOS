//
//  UserRequestDetailViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 11-05-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import RxSwift

class UserRequestDetailViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    let contactService = ContactServiceFactory.sharedInstance.contactsService
    let categoryService = ServiceFactory.sharedInstance.categoryService
    
    let disposeBag = DisposeBag()
    var detailItem: RequestModel? {
        didSet {
         // Update the view.
            //self.configureView()
        }
    }
    var editMode = true
    var skillCategories = [CategoryModel]()
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var ownerUIImageView: UIImageView!
    @IBOutlet weak var OwnerNameLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var requestDateLabel: UILabel!
    
    //MARK: View
    override func viewDidLoad() {
        self.configureView()
        detailTextView.editable = false
        titleTextView.editable = false;
        titleTextView.textContainer.maximumNumberOfLines = 1
        titleTextView.scrollEnabled = false
        categoryTextField.enabled = false
        saveButton.hidden = true;
        prepareEditMode()
        
        //Category picker
        categoryPicker.delegate = self
        categoryPicker.hidden = true
        categoryPicker.showsSelectionIndicator = true
        categoryTextField.inputView = UIView()
        loadCategories()
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.requestTableView.setEditing(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews(){
        self.titleTextView.setContentOffset(CGPointZero, animated: false)
    }
    
    func configureView(){
        self.titleTextView.text = detailItem?.title
        self.detailTextView.text = detailItem?.summary
        self.OwnerNameLabel.text = detailItem?.owner?.name
        
        if let category = detailItem?.categorys?.first?.name{
            self.categoryTextField.text = category
        }
        self.requestDateLabel.text = detailItem?.created!.regex("^([0-9]*-[0-9]*)*")[0]
    }

    // show edit button?
    private func prepareEditMode(){
        if(!editMode){
            self.editButton.hidden = true
            self.titleTextView.editable = true
        } else {
            self.chatButton.hidden = true
        }
    }
    
    @IBAction func contactButtonPressed(sender: UIButton) {
        let email = "mailto:\(detailItem!.owner!.username)"
        let url = NSURL(string: email)
        
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("CONTACT_ERROR_TITLE", comment: "Comment"), message: NSLocalizedString("CONTACT_ERROR_MESSAGE", comment: "Comment"), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    //MARK: Buttons
    func makeTextViewEditMarkup(){
        // make detailtextview look like textfield
        self.detailTextView.layer.borderWidth = 0.5
        self.detailTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.detailTextView.layer.cornerRadius = 5;
        self.detailTextView.clipsToBounds = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.titleTextView.layer.borderWidth = 0.5
        self.titleTextView.layer.borderColor = UIColor.whiteColor().CGColor
        self.titleTextView.layer.cornerRadius = 5;
        self.titleTextView.clipsToBounds = true
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        self.detailItem!.title = titleTextView.text!
        self.detailItem!.summary = self.detailTextView.text!
        ServiceFactory.sharedInstance.requestService.editUserRequest(self.detailItem!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func editButtonPressed(sender: UIButton) {
        self.saveButton.hidden = false
        self.detailTextView.editable = true
        self.titleTextView.editable = true
        self.saveButton.hidden = false
        categoryTextField.enabled = true
        makeTextViewEditMarkup()
    }
   
    //MARK: Category Picker
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return skillCategories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let index = skillCategories.startIndex.advancedBy(row) // index 1
        return skillCategories[index].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let index = skillCategories.startIndex.advancedBy(row) // index 1
        categoryTextField.text = skillCategories[index].name
        categoryPicker.hidden = true
        detailTextView.becomeFirstResponder()
    }
    
    func loadCategories() {
        self.skillCategories.removeAll()
        self.skillCategories = categoryService.categories
    }
    
    @IBAction func textFieldBeginEditing(sender: UITextField) {
        categoryPicker.hidden = false
    }
    
    //MARK: Hide Keyboard
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar = self.doneToolbar(#selector(self.doneButtonAction))
        self.titleTextView.inputAccessoryView = doneToolbar
        self.detailTextView.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.titleTextView.resignFirstResponder()
        self.detailTextView.resignFirstResponder()
    }
    
}
