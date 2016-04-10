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
        
    override func viewWillAppear(animated: Bool) {
        self.getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // profile rounded image
        self.ProfileImageView.layer.cornerRadius = self.ProfileImageView.frame.size.width / 2
        self.ProfileImageView.layer.borderWidth = 3.0
        self.ProfileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.ProfileImageView.layer.masksToBounds = true
        self.ProfileNameLabel.text = "profielnaam"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        self.ProfileNameLabel.text = model!.name
        self.AboutMeLabel.text = model!.summary
        self.ProfileImageView.image = UIImage(data: model!.profilePicture)
        let amountOfContacts: String = String(model!.contacts.count)
        self.FriendsLabel.text! = amountOfContacts
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            aboutMeHeader.text = segmentedControl.titleForSegmentAtIndex(segmentedControl.selectedSegmentIndex)
            AboutMeLabel.text = model!.summary
        case 1:
            aboutMeHeader.text = segmentedControl.titleForSegmentAtIndex(segmentedControl.selectedSegmentIndex)
            AboutMeLabel.text = ""
            for request in model!.requests{
                AboutMeLabel.text = AboutMeLabel.text + request["title"].stringValue + "\r\n"
            }
        default:
            break; 
        }
    }
    
    //MARK: DATA
    private func getData(){
        
        //check if URL is valid
        let profileURL = Config.url + profileUrl
        guard let url = NSURL(string: profileURL) else {
            print("Error: cannot create URL")
            return
        }
        
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    
                    
                    self.model = ProfileModel(jsonData: value)
                    self.setData()
                }
            case .Failure(let error):
                print(error)
            }
        }
        
        model?.id
    }
}