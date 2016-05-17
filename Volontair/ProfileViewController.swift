//
//  ProfileViewController.swift
//  Volontair
//
//  Created by Bryan Sijs on 21-03-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import QuartzCore

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var ProfileNameLabel: UILabel!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var AboutMeLabel: UITextView!
    @IBOutlet weak var FriendsLabel: UILabel!
    @IBOutlet weak var aboutMeHeader: UILabel!
    @IBOutlet weak var showRequestsButton: UIButton!
    
    let profileService = ProfileServiceFactory.sharedInstance.getProfileService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profiel"
        // profile rounded image
        self.ProfileImageView.layer.cornerRadius = self.ProfileImageView.frame.size.width / 2
        self.ProfileImageView.layer.borderWidth = 3.0
        self.ProfileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.ProfileImageView.layer.masksToBounds = true
        self.ProfileNameLabel.text = "profielnaam"
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.updateOnNotification), name: Config.profileNotificationKey, object: nil)
        
        setData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        
        if let data = ServiceFactory.sharedInstance.userService.getCurrentUser() {
            self.ProfileNameLabel.text = data.name
            self.AboutMeLabel.text = data.summary
            self.showRequestsButton.setTitle("\(data.requests!.count) Hulp aanvragen", forState: .Normal)
            //TODO: Contact numbers
            //self.FriendsLabel.text = "\(data..count) contacten"
            self.ProfileImageView.image = UIImage(data: data.profilePicture!)
//            let amountOfContacts: String = String(data.contacts.count)
//            self.FriendsLabel.text! = amountOfContacts
        }
    }
    
    //This will be triggered once the Data is updated.
    func updateOnNotification() {
        profileService.loadProfileFromServer()
        setData()
    }
    
    func makeRoundedImage(image: UIImage) -> UIImage{
        let imageLayer = CALayer()
        imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        imageLayer.contents = image.CGImage
        
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = image.size.width/2.5
        
        UIGraphicsBeginImageContext(image.size)
        
        imageLayer.renderInContext(UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
}