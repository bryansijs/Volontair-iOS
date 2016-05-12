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
        ServiceFactory.sharedInstance.requestService.loadRequestDataFromServer { (responseObject: [RequestModel]?, error: NSError?) in
            if ((error) != nil) {
                print(error)
            } else {
                if let requestArray = responseObject{
                    self.mapViewModel?.requests! = requestArray
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        Config.requestsUpdatedNotificationKey,
                        object: self.mapViewModel?.requests)
                }
            }
        }
    }
    
//    func getOffers() {
//        ServiceFactory.sharedInstance.offerService.loadOffersDataFromServer{ (responseObject: [OfferModel]?, error: NSError?) in
//            if ((error) != nil) {
//                print(error)
//            } else {
//                if let offersArray = responseObject{
//                    self.mapViewModel?.offers! = offersArray
//                    NSNotificationCenter.defaultCenter().postNotificationName(
//                        Config.offersUpdatedNotificationKey,
//                        object: self.mapViewModel?.offers)
//                }
//            }
//        }
//    }
    
    func getUsersInNeighbourhood() {
        ServiceFactory.sharedInstance.userService.loadUsersInNeighbourhood(self.completeGetUsersInNeighbourhood)
    }
    
    func completeGetUsersInNeighbourhood(users :[UserModel]?, error :NSError?) ->Void {
        if error != nil {
            print("Error getting user in neighbourhood", error)
        
        } else {
            var data : [UserMapModel] = []
            
            for user in users! { //transform userModel naar userMapModel TODO
                let coordinates = CLLocationCoordinate2D(latitude: 51.682449, longitude: 5.293167)
                let mapUser = UserMapModel(title: user.name, category: "TODO lijst van cats", summary: user.summary, coordinate: coordinates, created: "TODO not nessesary", updated: "notNessesary")
                data.append(mapUser)
            }
            
            self.mapViewModel?.users = data
            
        }
    }
}
