//
//  ProfileViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 21-03-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import Alamofire



class ProfileViewController: UIViewController {
    
    @IBOutlet weak var ProfileNameLabel: UILabel!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var AboutMeLabel: UITextView!
    @IBOutlet weak var FriendsLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var aboutMeHeader: UILabel!
    
    //TODO: right user number
    let profileUrl = "users/1"
    var model : ProfileModel?  = nil
    let userService = UserService.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // profile rounded image
        self.ProfileImageView.layer.cornerRadius = self.ProfileImageView.frame.size.width / 2
        self.ProfileImageView.layer.borderWidth = 3.0
        self.ProfileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.ProfileImageView.layer.masksToBounds = true
        self.ProfileNameLabel.text = "profielnaam"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.updateOnNotification), name: Config.profileNotificationKey, object: nil)
        setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        if let data = userService.profileModel?.name{
            self.ProfileNameLabel.text = userService.profileModel!.name
            self.AboutMeLabel.text = userService.profileModel!.summary
            self.ProfileImageView.image = UIImage(data: userService.profileModel!.profilePicture)
            let amountOfContacts: String = String(userService.profileModel!.contacts.count)
            self.FriendsLabel.text! = amountOfContacts
        }
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            aboutMeHeader.text = segmentedControl.titleForSegmentAtIndex(segmentedControl.selectedSegmentIndex)
            AboutMeLabel.text = userService.profileModel!.summary
        case 1:
            aboutMeHeader.text = segmentedControl.titleForSegmentAtIndex(segmentedControl.selectedSegmentIndex)
            AboutMeLabel.text = ""
            for request in userService.profileModel!.requests{
                AboutMeLabel.text = AboutMeLabel.text + request["title"].stringValue + "\r\n"
            }
        default:
            break; 
        }
    }
    
    //This will be triggered once the Data is updated.
    func updateOnNotification() {
        setData()
    }
}