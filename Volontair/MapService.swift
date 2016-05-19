//
//  MapService.swift
//  Volontair
//
//  Created by M Mommersteeg on 10/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class MapService {
    
    static let sharedInstance = MapService()
    
    private var mapViewModel: MapViewModel?
    
    init() {
        self.mapViewModel = MapViewModel()
    }
    
    func getMapViewModel() -> MapViewModel? {
        return self.mapViewModel
    }

    
    func getRequests() {
        ServiceFactory.sharedInstance.requestService.loadRequestDataFromServer(self.completeGetRequest)
    }
    
    func completeGetRequest(request :RequestModel) -> Void {
        if request.categorys?.count > 0 {
            print(request.categorys![0])
        }
        self.mapViewModel?.requests?.append(request)
    }
    
    func getUsersInNeighbourhood() {
        ServiceFactory.sharedInstance.userService.loadUsersInNeighbourhood(self.completeGetUsersInNeighbourhood)
    }
    
    func completeGetUsersInNeighbourhood(users :[UserModel]?, error :NSError?) ->Void {
        if error != nil {
            print("Error getting user in neighbourhood", error)
        
        } else {
            var data : [UserMapModel] = []
            
            for user in users! {
                ServiceFactory.sharedInstance.userService.loadUserCategorys(user)
                ServiceFactory.sharedInstance.userService.loadUserRequests(user)
                let mapUser = UserMapModel(user: user)
                data.append(mapUser)
            }
            
            self.mapViewModel?.users = data
            NSNotificationCenter.defaultCenter().postNotificationName(ApiConfig.userOffersNotificationKey, object: nil)
            
            if users![0].profilePicture == nil {
                ServiceFactory.sharedInstance.userService.loadProfilePictures( users , completionHandler: self.completeGetUsersInNeighbourhood)
            }
        }
    }
}
