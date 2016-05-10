//
//  Contstants.swift
//  Volontair
//
//  Created by Bryan Sijs on 07-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation
import MapKit

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
    
    static let defaultMapAnnotationImageSize = CGSize(width: 24, height: 24)
    
    static let profileUrl = "users/"
    static let dashboardUrl = "dashboard/"
    static let conversationUrl = "conversations/"
    static let categoryUrl = "categories/"
    
    //VolontairApiService
    static var facebookToken = ""
    static var VolontairApiToken = ""
    
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
