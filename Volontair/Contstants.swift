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
    static let offersEndPoint = "discover/offers"
    
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
}
