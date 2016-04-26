//
//  AddEmployViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 26-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import RxSwift

class AddEmployViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var offerView: UIView!
    

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
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
        
        // hide offer view
        offerView.hidden = true
        
        // default request field text
        titleTextField.placeholder = NSLocalizedString("TITLE",comment: "")
        categoryTextField.placeholder = NSLocalizedString("CATEGORY",comment: "")
        messageTextField.text = NSLocalizedString("MESSAGE",comment: "")
        
        //Category picker
        categoryPicker.delegate = self
        categoryPicker.hidden = true
        categoryPicker.showsSelectionIndicator = true
        
        loadCategories()
    }
    
    //MARK: SegmentedControl
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
            case 0: offerView.hidden = true
            case 1: offerView.hidden = false
            default: offerView.hidden = true
        }
        
    }
    
    //MARK: UIPicker
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: Data
    
    func loadCategories() {
        self.skillCategories.removeAll()
        skillCategories["-"] = CategoryModel(name: "-", iconName: "")
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
        categoryPicker.hidden = true;
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
