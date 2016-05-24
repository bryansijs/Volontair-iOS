//
//  Contstants.swift
//  Volontair
//
//  Created by Bryan Sijs on 07-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import MapKit
import Alamofire

struct Config{
    static let url = "https://volontairtest-mikero.rhcloud.com/"
    
    static let requestsEndPoint = "discover/requests"
    static let requestsPOSTPoint = "discover/requests"
    static let offersEndPoint = "discover/offers"
    static let offersPOSTPoint = "discover/offers"
    
    
    static let requestDiscipline = "Request"
    static let offerDiscipline = "Offer"
    
    static let requestsUpdatedNotificationKey = "REQUESTS_UPDATED"
    static let offersUpdatedNotificationKey = "OFFERS_UPDATED"
    
    static let defaultMapLatitudeDelta: Double = 1
    static let defaultMapLongitudeDelta: Double = 1
    
    static let profileUrl = "users/"
    static let dashboardUrl = "dashboard/"
    static let conversationUrl = "conversations/"
    static let categoryUrl = "categories/"
    
    // provided from conversations
    static let messagesUrl = "messages/"
    static let profileNotificationKey = "ProfileDataUpdated"
    static let dashboardNotificationKey = "DashboardDataUpdated"
    
    static let defaultCategoryIconUrl = "icon_default"
    
    // categories mapped to icons
    static let categoryIconDictionary: [CategoryIconModel] =
    [
        CategoryIconModel(category: "technical_questions", iconUrl: "icon_technical_questions"),
        CategoryIconModel(category: "social_activities", iconUrl: "icon_social_activities"),
        CategoryIconModel(category: "housekeeping", iconUrl: "icon_housekeeping"),
        CategoryIconModel(category: "transportation", iconUrl: "icon_transportation"),
        CategoryIconModel(category: "repairing_and_replacing", iconUrl: "icon_repairing_and_replacing"),
        CategoryIconModel(category: "events", iconUrl: "icon_events")
    ]
}

struct ApiConfig{
    //static let baseUrl = "http://192.168.178.49:6789/api/v1"
    static let baseUrl = "https://volontair.herokuapp.com/api/v1"
    
    static var headers : [String: String] = [:]
    
    static let requestsEndPoint = "/requests/"
    static let offersEndPoint = "/offers/"
    
    
    static let requestDiscipline = "Request"
    static let offerDiscipline = "Offer"
    
    static let requestsUpdatedNotificationKey = "REQUESTS_UPDATED"
    static let offersUpdatedNotificationKey = "OFFERS_UPDATED"
    
    static let defaultMapLatitudeDelta: Double = 1
    static let defaultMapLongitudeDelta: Double = 1
    
    static let defaultMapAnnotationImageSize = CGSize(width: 24, height: 24)
    
    static let profileUrl = "/profile/"
    static let usersUrl = "/users/"
    static let dashboardUrl = "/dashboard/"
    static let conversationUrl = "/conversations/"
    static let starterConversationsUrl = "/starterConversations/"
    static let listenerConversationsUrl = "/listenerConversations/"
    static let categoryUrl = "/categories/"
    
    //VolontairApiService
    //static let registerFacebookTokenUrl = "http://192.168.178.49:6789/auth/facebook/client?accessToken=";
    static let registerFacebookTokenUrl = "https://volontair.herokuapp.com/auth/facebook/client?accessToken=";
    
    //static let getVolontairApiTokenUrl = "http://192.168.178.49:6789/oauth/authorize?response_type=token&client_id=volontair&redirect_uri=/";
    static let getVolontairApiTokenUrl = "https://volontair.herokuapp.com/oauth/authorize?response_type=token&client_id=volontair&redirect_uri=/";
    
    static let getMeUrl = "/users/me"
    
    // provided from conversations
    static let messagesUrl = "/messages/"
    static let profileNotificationKey = "ProfileDataUpdated"
    static let dashboardNotificationKey = "DashboardDataUpdated"
    
    static let defaultCategoryIconUrl = "icon_default"
    
    // provided from map
    static let requestNotificationKey = "RequestsDataUpdated"
    static let requestInternalUpdate = "RequestInternalUpdate"
    static let userOffersNotificationKey = "UsersOffersDataUpdated"
    static let requestDataUpdateNotificationKey = "UsersOffersDataUpdated"
    static let mapIconDiameter = 40
    
    //Facebook 
    static let facebookUsernamePreference = "volontair.preferences.username"
    
    // categories mapped to icons
    static let categoryIconDictionary: [CategoryIconModel] =
        [
            CategoryIconModel(category: "technical_questions", iconUrl: "icon_technical_questions"),
            CategoryIconModel(category: "social_activities", iconUrl: "icon_social_activities"),
            CategoryIconModel(category: "housekeeping", iconUrl: "icon_housekeeping"),
            CategoryIconModel(category: "transportation", iconUrl: "icon_transportation"),
            CategoryIconModel(category: "repairing_and_replacing", iconUrl: "icon_repairing_and_replacing"),
            CategoryIconModel(category: "events", iconUrl: "icon_events")
    ]
    
    static let categoryIcons : [String: UIImage] = [
        "Technische vragen" : UIImage(named: "icon_technical_questions")!,
        "Sociale activiteiten" : UIImage(named: "icon_social_activities")!,
        "Huis en tuin" : UIImage(named: "icon_housework")!,
        "Vervoer" : UIImage(named: "icon_transportation")!,
        "Reparaties en vervangen" : UIImage(named: "icon_repairing_and_replacing")!,
        "Evenementen" : UIImage(named: "icon_events")!
    ]
    
    static let categoryIconsWhite : [String: UIImage] = [
        "Technische vragen" : UIImage(named: "icon_technical_questions_white")!,
        "Sociale activiteiten" : UIImage(named: "icon_social_activities_white")!,
        "Huis en tuin" : UIImage(named: "icon_housework_white")!,
        "Vervoer" : UIImage(named: "icon_transportation_white")!,
        "Reparaties en vervangen" : UIImage(named: "icon_repairing_and_replacing_white")!,
        "Evenementen" : UIImage(named: "icon_events_white")!
    ]
}
