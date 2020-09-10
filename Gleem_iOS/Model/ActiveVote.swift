//
//  ActiveVote.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/11/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import GeoFire
import Foundation
struct ActiveVote:  Encodable, Decodable ,Identifiable{ 
    var attr1 : Int
    var attr2: Int
    var attr3: Int
    var attr4: Int
    var attr5: Int
    var attrNames: [String]
    var numVote: Int
    var createdDate: Double
    var lastModifiedDate: Double
    var id : String
    var email: String
    var imageLocation: String
    var username: String
    var age: String
    var sex: String
    var location: String
    var occupation: String
    var description: String
    

    init(attr1: Int, attr2: Int, attr3: Int, attr4: Int, attr5: Int,attrNames: [String], numVote: Int, createdDate: Double, lastModifiedDate: Double,id: String, email: String, imageLocation: String, username: String,
         age: String, sex:String , location: String, occupation:String, description:String  ) {
        self.attr1 = attr1
        
        self.attr2 = attr2
        self.attr3 = attr3
        self.attr4 = attr4
        self.attr5 = attr5
        
        
        self.attrNames = attrNames
        self.numVote = numVote
        self.createdDate = createdDate
        self.lastModifiedDate = lastModifiedDate
        self.id = id
        self.email = email
        self.imageLocation = imageLocation
        self.username = username
        self.age = age
        self.sex = sex
        self.location = location
        self.occupation = occupation
        self.description = description
    }
    init(_dictionary: NSDictionary) {
        attr1 = _dictionary["attr1"] as! Int
        attr2 = _dictionary["attr2"] as! Int
        attr3 = _dictionary["attr3"] as! Int
        attr4 = _dictionary["attr4"] as! Int
        attr5 = _dictionary["attr5"] as! Int
        attrNames = _dictionary["attrNames"] as! [String]
        numVote = _dictionary["numVote"] as! Int
        createdDate = _dictionary["createdDate"] as! Double
        lastModifiedDate = _dictionary["lastModifiedDate"] as! Double
        id = _dictionary["id"] as! String
        email = _dictionary["email"] as! String
        imageLocation = _dictionary["imageLocation"] as! String
        username = _dictionary["username"] as! String
        age = _dictionary["age"] as! String
        sex = _dictionary["sex"] as! String
        location = _dictionary["location"] as! String
        occupation = _dictionary["occupation"] as! String
        description = _dictionary["description"] as! String

        
    }
}
