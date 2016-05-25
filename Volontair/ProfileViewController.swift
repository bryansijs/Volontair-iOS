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
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var editButton: UIButton!

    var editMode = true
    
    var user: UserModel? {
        didSet {
            // Update the view.
            //self.setdata()
        }
    }
    @IBAction func StartConversation(sender: AnyObject) {
        
        let email = user!.username
        let url = NSURL(string: "mailto:\(email)")
        
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("CONTACT_ERROR_TITLE", comment: "Comment"), message: NSLocalizedString("CONTACT_ERROR_MESSAGE", comment: "Comment"), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewControllerAnimated(true)
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
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
        
        if editMode {
            self.contactButton.hidden = true
        } 
    }
    
    override func viewWillAppear(animated: Bool) {
        setData()
        if(!editMode){
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if(!editMode){
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        if(self.user == nil){
            self.user = ServiceFactory.sharedInstance.userService.getCurrentUser()
        }
        // show other person profile
        if let userProfile = self.user{
            self.ProfileNameLabel.text = userProfile.name
            self.AboutMeLabel.text = userProfile.summary
            self.AboutMeLabel.editable = false
            self.showRequestsButton.setTitle("\(userProfile.requests!.count) Hulp aanvragen", forState: .Normal)
            //TODO: Contact numbers
            //self.FriendsLabel.text = "\(data..count) contacten"
            self.ProfileImageView.image = UIImage(data: userProfile.profilePicture!)
            //            let amountOfContacts: String = String(data.contacts.count)
            //            self.FriendsLabel.text! = amountOfContacts
            editableMode()
            setRequestButtonState()

        
        }
    }
    
    private func editableMode(){
        if(!editMode){
            self.AboutMeLabel.editable = false
            self.editButton.hidden = true
        }
    }
    func setRequestButtonState(){
        if let userProfile = self.user{
            if(userProfile.requests!.count < 1){
                self.showRequestsButton.enabled = false
            } else {
                self.showRequestsButton.enabled = true
            }
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
    
    //showProfileRequests
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showProfileRequests") {
            // pass data to List
            let newController = segue.destinationViewController as! UserRequestTableViewController
            newController.requests = (user!.requests)!
            newController.editMode = self.editMode
        }
    }
}