//
//  UserProfile.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 8/22/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import Foundation
import FirebaseAuth

struct UserProfile: Encodable, Decodable ,Identifiable{
    //    var id: ObjectIdentifier
    
    var id : String
    var email: String
    var profileImageUrl: String
    var username: String
    var age: String
    var sex: String
    var createdDate : Double
    var point_avail : Int
    var location : String
    var occupation : String
    var longitude : String
    var latitude : String
    var description : String


    init(id: String, email: String, profileImageUrl: String, username: String, age: String, sex:String, createdDate : Double, point_avail: Int, location: String, occupation: String, longitude: String, latitude : String, description: String) {
        self.id = id
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.username = username
        self.age = age
        self.sex = sex
        self.createdDate = createdDate
        self.point_avail = point_avail
        self.location = location
        self.occupation = occupation
        self.longitude = longitude
        self.latitude = latitude
        self.description = description

    }
    init(_dictionary: NSDictionary) {
        id = _dictionary["id"] as! String
        email = _dictionary["email"] as! String
        profileImageUrl = _dictionary["profileImageUrl"] as! String
        username = _dictionary["username"] as! String
        age = _dictionary["age"] as! String
        sex = _dictionary["sex"] as! String
        createdDate = _dictionary["createdDate"] as! Double
        point_avail = _dictionary["point_avail"] as! Int
        location = _dictionary["location"] as! String
        occupation = _dictionary["occupation"] as! String
        longitude = _dictionary["longitude"] as! String
        latitude = _dictionary["latitude"] as! String
        description = _dictionary["description"] as! String

        
    }
    

    
    
}
