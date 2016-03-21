//
//  ProfileViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 21-03-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var ProfileNameLabel: UILabel!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var AboutMeLabel: UITextView!
    
    let notificationKey = "profileDataChanged"
    let model = ProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateOnNotification", name: notificationKey, object: nil)
        
        self.ProfileImageView.layer.cornerRadius = self.ProfileImageView.frame.size.width / 2
        self.ProfileImageView.layer.borderWidth = 3.0
        self.ProfileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        //self.ProfileImageView.clipsToBounds = true
        self.ProfileImageView.layer.masksToBounds = true
        self.ProfileNameLabel.text = "profielnaam"
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(){
        print(model.data!["offersCategories"])
        self.ProfileNameLabel.text = model.data!["name"] as? String
        self.AboutMeLabel.text = model.data!["summary"] as? String
        self.ProfileImageView.image = UIImage(data: model.profilePicture!)
    }
    
    //This will be triggered once the Data is updated.
    func updateOnNotification() {
        getData();
    }
}