//
//  AddEmployViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 26-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation

class AddEmployViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    let categoryService = ServiceFactory.sharedInstance.categoryService
    let disposeBag = DisposeBag()
    var selectedCategory: CategoryModel?
    
    //MARK: INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make textview look like textfield
        self.messageTextField.layer.borderWidth = 0.5
        self.messageTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.messageTextField.layer.cornerRadius = 5;
        self.messageTextField.clipsToBounds = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        // default request field text
        titleTextField.placeholder = NSLocalizedString("TITLE",comment: "")
        categoryTextField.placeholder = NSLocalizedString("CATEGORY",comment: "")
        categoryTextField.inputView = UIView()
        
        //Category picker
        categoryPicker.delegate = self
        categoryPicker.hidden = true
        categoryPicker.showsSelectionIndicator = true
        
        //default title
        self.navigationItem.title = NSLocalizedString("NEW_REQUEST",comment: "")
        submitButton.setTitle(NSLocalizedString("REQUEST",comment: ""), forState: .Normal)
        messageLabel.text = NSLocalizedString("REQUEST_MESSAGE",comment: "")
        
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    //MARK: Form
    @IBAction func submitButtonPressed(sender: UIButton) {
        submitRequestForm()
    }
    
    private func submitRequestForm(){
        let validated = validateRequestForm()
        if validated {
            let currentUser = ServiceFactory.sharedInstance.userService.getCurrentUser()!
            let request = RequestModel(title: self.titleTextField.text!, summary: self.messageTextField.text, closed: false, created: getCurrentDateString(), updated: getCurrentDateString(), category: self.selectedCategory!, owner: currentUser)
            currentUser.requests?.append(request)
            ServiceFactory.sharedInstance.requestService.submitRequest(request)
            showRequestSuccessfulAlert()
        }
    }
    
    private func validateRequestForm() -> Bool{
        if titleTextField.text == ""{
            titleTextField.backgroundColor = UIColor.redColor()
            return false
        }
        if categoryTextField.text == ""{
            categoryTextField.backgroundColor = UIColor.redColor()
            return false
        }
        if messageTextField.text == "" || messageTextField.text == NSLocalizedString("MESSAGE",comment: ""){
            messageTextField.backgroundColor = UIColor.redColor()
            return false
        }
        return true
    }
    
    private func getCurrentDateString() -> String{
        let dateFormatter = NSDateFormatter()
        return dateFormatter.stringFromDate(NSDate())
    }
    
    private func showRequestSuccessfulAlert(){
        let refreshAlert = UIAlertController(title: NSLocalizedString("REQUEST",comment: ""), message: NSLocalizedString("REQUEST_MESSAGE_SUCCESSFULL",comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewControllerAnimated(true)
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    //MARK: UIPicker
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return categoryService.categories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let index = categoryService.categories.startIndex.advancedBy(row) // index 1
        return categoryService.categories[index].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let index = categoryService.categories.startIndex.advancedBy(row) // index 1
        self.selectedCategory = categoryService.categories[index]
        categoryTextField.text = categoryService.categories[index].name
        categoryPicker.hidden = true
        messageTextField.becomeFirstResponder()
    }
    @IBAction func textFieldBeginEditing(sender: UITextField) {
        print("editor mode")
        categoryPicker.hidden = false
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("editor mode")
        categoryPicker.hidden = false
        return false
    }
    
    //MARK: Hide Keyboard
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar = self.doneToolbar(#selector(self.doneButtonAction))
        self.messageTextField.inputAccessoryView = doneToolbar
        self.titleTextField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.messageTextField.resignFirstResponder()
        self.titleTextField.resignFirstResponder()
    }
}
