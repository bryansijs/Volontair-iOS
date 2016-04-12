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
    
    var profileModel : ProfileModel?  = nil
    var dashboardmodel: DashboardModel? = nil
    
    func getUserProfileModel() -> ProfileModel?{
        return profileModel
    }
    
    func loadProfileDataFromServer(userId: Int){
        
        //check if URL is valid
        let profileURL = NSURL(string: Config.url + Config.profileUrl + String(userId))
        
        Alamofire.request(.GET, profileURL!).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.profileModel = ProfileModel(jsonData: value)
                    NSNotificationCenter.defaultCenter().postNotificationName(Config.profileNotificationKey, object: self.profileModel)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func loadDashboardDataFromServer(){
        let dashboardURL = Config.url + "dashboard"
        guard let dashURL = NSURL(string: dashboardURL) else {
            print("Error: cannot create URL")
            return
        }
        
        Alamofire.request(.GET, dashURL).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.dashboardmodel = DashboardModel(jsonData: value)
                    NSNotificationCenter.defaultCenter().postNotificationName(Config.dashboardNotificationKey, object: self.profileModel)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}
