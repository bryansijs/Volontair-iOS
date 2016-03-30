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
    
    //TODO: right user number
    var url = "http://volontairtest-mikero.rhcloud.com/"
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
        self.FriendsLabel.text! += amountOfContacts
    }
    
    //MARK: DATA
    private func getData(){
        
        //check if URL is valid
        let profileURL = url + profileUrl
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
    }
}