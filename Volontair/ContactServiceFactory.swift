//
//  ContactServiceFactory.swift
//  Volontair
//
//  Created by Bryan Sijs on 14-04-16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import Foundation

class ContactServiceFactory  {
    static let sharedInstance = ContactServiceFactory()
    
    let contactsService = ContactsService()
    
    private init(){
        print("init ContactsServiceFactory")
    }
}