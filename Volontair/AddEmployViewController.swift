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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    var skillCategories = [String: CategoryModel]()
    let contactSercvice = ContactServiceFactory.sharedInstance.getContactsService()
    let disposeBag = DisposeBag()
    
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
        
        //Category picker
        categoryPicker.delegate = self
        categoryPicker.hidden = true
        categoryPicker.showsSelectionIndicator = true
        
        //default title
        self.navigationItem.title = NSLocalizedString("NEW_REQUEST",comment: "")
        submitButton.setTitle(NSLocalizedString("REQUEST",comment: ""), forState: .Normal)
        messageLabel.text = NSLocalizedString("REQUEST_MESSAGE",comment: "")
        
        loadCategories()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    //MARK: SegmentedControl
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:  self.navigationItem.title = NSLocalizedString("NEW_REQUEST",comment: ""); messageLabel.text = NSLocalizedString("REQUEST_MESSAGE",comment: "")
        case 1:  self.navigationItem.title = NSLocalizedString("NEW_OFFER",comment: ""); messageLabel.text = NSLocalizedString("OFFER_MESSAGE",comment: "")
            default: self.navigationItem.title = NSLocalizedString("NEW_REQUEST",comment: "")
        }
        
    }
    //MARK: Data
    
    func loadCategories() {
        self.skillCategories.removeAll()

        contactSercvice.categories()
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)))
            .observeOn(MainScheduler.instance)
            .toArray()
            .subscribe(onNext: { (json) -> Void in
                if json.count > 0{
                    for i in 0...json.count-1{
                        if let category = json[i] as? CategoryModel{
                            self.skillCategories[category.name] = category
                        }
                    }
                }
                self.categoryPicker.reloadAllComponents()
            }).addDisposableTo(self.disposeBag)
    }
    
    //MARK: Form
    @IBAction func submitButtonPressed(sender: UIButton) {
        if(segmentedControl.selectedSegmentIndex == 0){
            submitRequestForm()
        } else {
            submitOfferForm()
        }
    }
    
    private func submitRequestForm(){
        let validated = validateRequestForm()
        if validated {
            let request = RequestModel(title: titleTextField.text, category: categoryTextField.text!, summary: messageTextField.text, coordinate: CLLocationCoordinate2D(), created: getCurrentDateString() , updated: getCurrentDateString(), iconKey: categoryTextField.text!)
            ServiceFactory.sharedInstance.requestService.submitRequest(request)
        
            showRequestSuccessfulAlert()
        }
    }
    
    private func submitOfferForm(){
        let validated = validateRequestForm()
        if validated {
            let offer = OfferModel(title: titleTextField.text, category: categoryTextField.text!, summary: messageTextField.text, coordinate: CLLocationCoordinate2D(), created: getCurrentDateString(), updated: getCurrentDateString(), iconKey: categoryTextField.text!)
            ServiceFactory.sharedInstance.offerService.submitOffer(offer)
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
        return skillCategories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let index = skillCategories.startIndex.advancedBy(row) // index 1
        return skillCategories.keys[index]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let index = skillCategories.startIndex.advancedBy(row) // index 1
        categoryTextField.text = skillCategories[index].0
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


}
