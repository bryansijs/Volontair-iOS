//
//  UserService.swift
//  Volontair
//
//  Created by Bryan Sijs on 09-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire

class UserService  {
    static let sharedInstance = UserService()
    private init(){
        print("init UserService")
    }
    
    var model : ProfileModel?  = nil
    
    func getUserProfileModel() -> ProfileModel?{
        return model
    }
    
    func loadProfileDataFromServer(profileUrl: String){
        
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
                    NSNotificationCenter.defaultCenter().postNotificationName(Config.profileNotificationKey, object: self.model)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}
