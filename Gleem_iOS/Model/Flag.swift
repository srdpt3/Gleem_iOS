//
//  Flag.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/14/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI


import Foundation
struct Flag:  Encodable, Decodable ,Identifiable{
    var id : String
    var email: String
    var imageLocation: String
    var username: String
    var reason: String
    var date: Double
    var reporter : String

    
    
    init(id: String, email: String, imageLocation: String, username: String, reason: String ,reporter: String, date: Double) {


        self.id = id
        self.email = email
        self.imageLocation = imageLocation
        self.username = username
        self.reason = reason
        self.date = date
        self.reporter = reporter
        
    }
    init(_dictionary: NSDictionary) {
   
        id = _dictionary["id"] as! String
        email = _dictionary["email"] as! String
        imageLocation = _dictionary["imageLocation"] as! String
        username = _dictionary["username"] as! String
        reason = _dictionary["reason"] as! String
        reporter = _dictionary["reporter"] as! String
        date = _dictionary["date"] as! Double
        
    }
}
