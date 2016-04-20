//
//  PickerTestViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 20-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class PickerTestViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    
    var categorys = ["Cat One", "Cat Two", "Cat Three"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.delegate = self
    
        categoryPicker.hidden = true
        categoryTextField.text = categorys[0]
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return categorys.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorys[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        categoryTextField.text = categorys[row]
        categoryPicker.hidden = true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("editor mode")
        categoryPicker.hidden = false
        return false
    }


}
